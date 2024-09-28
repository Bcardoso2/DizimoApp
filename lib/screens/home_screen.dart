import 'package:flutter/material.dart';
import 'dart:async';
import 'cadastro_dizimista_screen.dart';
import '../services/api_service.dart';
import '../models/dizimo.dart';
import '../models/dizimista.dart';
import 'dizimos_screen.dart';
import 'dizimistas_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedPeriodo = 'mensal';
  final ApiService apiService = ApiService();

  List<Dizimista> dizimistas = [];
  List<Dizimo> ultimosDizimos = [];
  Timer? timer;

  @override
  void initState() {
    super.initState();;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _fetchData() async {
    try {
      dizimistas = await apiService.listarDizimistas();
      ultimosDizimos = await apiService.listarUltimosDizimos();
      setState(() {});
    } catch (e) {
      print('Erro ao carregar dados: $e');
    }
  }

  Future<List<Dizimo>> _getGraficoData() async {
    switch (_selectedPeriodo) {
      case 'diario':
        return await apiService.listarDepositosDiarios();
      case 'mensal':
        return await apiService.listarDepositosMensais();
      case 'todos':
        return await apiService.listarDepositosTodos();
      default:
        return [];
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dízimo App'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CadastroDizimistaScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _getSelectedWidget(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monetization_on),
            label: 'Dízimos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Dizimistas',
          ),
          
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _getSelectedWidget() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboard(); 
      case 1:
        return DizimosScreen(dizimos: ultimosDizimos);
      case 2:
        return DizimistasScreen(dizimistas: dizimistas);
      default:
        return Container();
    }
  }

  Widget _buildDashboard() {
    double totalValorDizimos = ultimosDizimos.fold(0.0, (total, dizimo) => total + dizimo.valor);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total de Dízimos', style: TextStyle(fontSize: 16)),
                      Text('R\$ ${totalValorDizimos.toStringAsFixed(2)}', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
              Card(
                elevation: 4,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Total de Dizimistas', style: TextStyle(fontSize: 16)),
                      Text('${dizimistas.length}', style: TextStyle(fontSize: 20)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Text('Selecione o Período', style: TextStyle(fontSize: 20)),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPeriodButton('Diário', 'diario'),
              _buildPeriodButton('Mensal', 'mensal'),
              _buildPeriodButton('Total', 'todos'),
            ],
          ),
          SizedBox(height: 40),
          FutureBuilder<Widget>(
            future: _buildBarChart(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro ao carregar gráfico'));
              } else {
                return snapshot.data ?? Container();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodButton(String title, String periodo) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedPeriodo = periodo;
          _fetchData();
        });
      },
      child: Text(title),
    );
  }

  Future<Widget> _buildBarChart() async {
    List<Dizimo> dadosGrafico = await _getGraficoData();

    if (dadosGrafico.isEmpty) {
      return Center(child: Text('Sem dados para exibir'));
    }

    List<BarChartGroupData> barGroups = dadosGrafico.asMap().entries.map((entry) {
      int index = entry.key;
      Dizimo dizimo = entry.value;
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: dizimo.valor,
            color: Colors.blue,
          ),
        ],
      );
    }).toList();

    return Container(
      height: 350,
      child: BarChart(
        BarChartData(
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 38,
                getTitlesWidget: (value, meta) {
                  return Text(
                    'Período ${value.toInt() + 1}', // Exibindo o índice + 1
                    style: TextStyle(color: Colors.black),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    '${value.toInt()}',
                    style: TextStyle(color: Colors.black),
                  );
                },
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
          gridData: FlGridData(show: true),
          alignment: BarChartAlignment.spaceAround,
          maxY: dadosGrafico.map((dizimo) => dizimo.valor).reduce((a, b) => a > b ? a : b),
        ),
      ),
    );
  }
}
