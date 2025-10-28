import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/workout_provider.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, int> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    await provider.loadWorkouts();

    final stats = await provider.getWorkoutStats();
    setState(() {
      _stats = stats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverviewCard(),
              const SizedBox(height: 20),
              _buildWorkoutFrequencyChart(),
              const SizedBox(height: 20),
              _buildMuscleGroupDistribution(),
              const SizedBox(height: 20),
              _buildProgressInsights(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  'Total Workouts',
                  _stats['totalWorkouts']?.toString() ?? '0',
                  Icons.fitness_center,
                  Colors.blue,
                ),
                _buildStatColumn(
                  'This Week',
                  _stats['thisWeekWorkouts']?.toString() ?? '0',
                  Icons.calendar_today,
                  Colors.green,
                ),
                _buildStatColumn(
                  'Total Sets',
                  _stats['totalSets']?.toString() ?? '0',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 36),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWorkoutFrequencyChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Workout Frequency (Last 7 Days)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Consumer<WorkoutProvider>(
                builder: (context, provider, child) {
                  final now = DateTime.now();
                  final last7Days = List.generate(7, (index) {
                    return now.subtract(Duration(days: 6 - index));
                  });

                  final workoutCounts = last7Days.map((date) {
                    final count = provider.workouts.where((workout) {
                      return workout.startTime.year == date.year &&
                          workout.startTime.month == date.month &&
                          workout.startTime.day == date.day &&
                          workout.completed;
                    }).length;
                    return count.toDouble();
                  }).toList();

                  if (workoutCounts.every((count) => count == 0)) {
                    return Center(
                      child: Text(
                        'No workout data available',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    );
                  }

                  return BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: workoutCounts.reduce((a, b) => a > b ? a : b) + 1,
                      barTouchData: BarTouchData(enabled: true),
                      titlesData: FlTitlesData(
                        show: true,
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                              final dayIndex = (last7Days[value.toInt()].weekday - 1) % 7;
                              return Text(
                                days[dayIndex],
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(fontSize: 10),
                              );
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: workoutCounts.asMap().entries.map((entry) {
                        return BarChartGroupData(
                          x: entry.key,
                          barRods: [
                            BarChartRodData(
                              toY: entry.value,
                              color: Theme.of(context).colorScheme.primary,
                              width: 20,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(6),
                                topRight: Radius.circular(6),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMuscleGroupDistribution() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Muscle Group Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: Center(
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        value: 25,
                        title: 'Chest',
                        color: Colors.red,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: 20,
                        title: 'Back',
                        color: Colors.blue,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: 30,
                        title: 'Legs',
                        color: Colors.green,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: 15,
                        title: 'Arms',
                        color: Colors.purple,
                        radius: 60,
                      ),
                      PieChartSectionData(
                        value: 10,
                        title: 'Other',
                        color: Colors.orange,
                        radius: 60,
                      ),
                    ],
                    sectionsSpace: 2,
                    centerSpaceRadius: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressInsights() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progress Insights',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildInsightItem(
              Icons.trending_up,
              'Consistency',
              'You worked out ${_stats['thisWeekWorkouts'] ?? 0} times this week',
              Colors.green,
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              Icons.fitness_center,
              'Volume',
              'Total of ${_stats['totalSets'] ?? 0} sets completed',
              Colors.blue,
            ),
            const SizedBox(height: 12),
            _buildInsightItem(
              Icons.emoji_events,
              'Streak',
              'Keep going to build your streak!',
              Colors.orange,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightItem(IconData icon, String title, String subtitle, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
