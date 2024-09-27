import 'package:flutter/material.dart';
import 'dart:async'; // Para usar Timer
import 'cadastro_dizimista_screen.dart';
import 'historico_depositos_screen.dart'; // Importando a tela de histórico
import '../services/api_service.dart';
import '../models/dizimo.dart';
import '../models/dizimista.dart';
import 'dizimos_screen.dart';
import 'dizimistas_screen.dart';
import 'package:fl_chart/fl_chart.dart'; // Importando o pacote para gráficos

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String _selectedPeriodo = 'mensal'; // Período selecionado para o gráfico
  final ApiService apiService = ApiService();
  
  List<Dizimista> dizimistas = [];
  List<Dizimo> ultimosDizimos = [];
  Timer? timer; // Timer para atualização

  @override
  void initState() {
    super.initState();
    _fetchData();
    // Iniciar o timer para atualização a cada 5 segundos
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => _fetchData());
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancelar o timer ao descartar o widget
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
          // IconButton(
          //   icon: Icon(Icons.history),
          //   onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => HistoricoDepositosScreen(periodo: _selectedPeriodo), // Navegando para a tela de histórico
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
      body: _buildDashboard(),
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

  // Método para construir a Dashboard
  Widget _buildDashboard() {
    double totalValorDizimos = ultimosDizimos.fold(0.0, (total, dizimo) => total + (dizimo.valor ?? 0.0));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dashboard', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
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
          SizedBox(height: 20),
          Text('Selecione o Período', style: TextStyle(fontSize: 20)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPeriodButton('Diário', 'diario'),
              _buildPeriodButton('Mensal', 'mensal'),
              _buildPeriodButton('Total', 'todos'),
            ],
          ),
          SizedBox(height: 20),
          _buildChart(),
        ],
      ),
    );
  }

  // Método para construir os botões de período
  Widget _buildPeriodButton(String title, String periodo) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedPeriodo = periodo;
        });
      },
      child: Text(title),
    );
  }

  // Método para construir o gráfico
  Widget _buildChart() {
    // Substitua pelos dados reais do gráfico conforme necessário
    List<FlSpot> spots = [
      FlSpot(0, 10),
      FlSpot(1, 20),
      FlSpot(2, 30),
      FlSpot(3, 50),
      FlSpot(4, 60),
      FlSpot(5, 80),
      FlSpot(6, 70),
      FlSpot(7, 90),
      FlSpot(8, 100),
    ];

    return AspectRatio(
      aspectRatio: 1.5,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: true),
          borderData: FlBorderData(show: true),
          minX: 0,
          maxX: 8,
          minY: 0,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Color(0),
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
