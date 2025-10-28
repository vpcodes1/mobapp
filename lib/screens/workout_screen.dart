import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/workout_provider.dart';
import '../models/exercise.dart';
import '../models/workout_exercise.dart';
import '../models/workout_set.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final provider = Provider.of<WorkoutProvider>(context, listen: false);
    await provider.loadExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workout'),
        centerTitle: true,
      ),
      body: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
          if (provider.currentWorkout == null) {
            return _buildNoActiveWorkout(context, provider);
          }

          return _buildActiveWorkout(context, provider);
        },
      ),
      floatingActionButton: Consumer<WorkoutProvider>(
        builder: (context, provider, child) {
          if (provider.currentWorkout != null) {
            return FloatingActionButton.extended(
              onPressed: () => _showAddExerciseDialog(context, provider),
              icon: const Icon(Icons.add),
              label: const Text('Add Exercise'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNoActiveWorkout(BuildContext context, WorkoutProvider provider) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.fitness_center,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 24),
          Text(
            'No active workout',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start a workout from the home screen',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 32),
          FilledButton.icon(
            onPressed: () => _showStartWorkoutDialog(context, provider),
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Workout'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveWorkout(BuildContext context, WorkoutProvider provider) {
    final workout = provider.currentWorkout!;
    final duration = DateTime.now().difference(workout.startTime);

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          color: Theme.of(context).colorScheme.primaryContainer,
          child: Column(
            children: [
              Text(
                workout.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${duration.inMinutes} minutes',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: () => _endWorkout(context, provider),
                    icon: const Icon(Icons.check),
                    label: const Text('Finish'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () => _cancelWorkout(context, provider),
                    icon: const Icon(Icons.close),
                    label: const Text('Cancel'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: FutureBuilder<List<WorkoutExercise>>(
            future: provider.getWorkoutExercises(workout.id!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No exercises yet',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap the button below to add exercises',
                        style: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final workoutExercise = snapshot.data![index];
                  final exercise = provider.getExerciseById(workoutExercise.exerciseId);

                  if (exercise == null) return const SizedBox.shrink();

                  return _buildExerciseCard(context, provider, workoutExercise, exercise);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildExerciseCard(
    BuildContext context,
    WorkoutProvider provider,
    WorkoutExercise workoutExercise,
    Exercise exercise,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: _getCategoryColor(exercise.category),
                  child: Text(
                    exercise.name[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        exercise.category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            FutureBuilder<List<WorkoutSet>>(
              future: provider.getExerciseSets(workoutExercise.id!),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No sets yet');
                }

                return Column(
                  children: [
                    ...snapshot.data!.map((set) => _buildSetRow(set)),
                  ],
                );
              },
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: () => _showAddSetDialog(context, provider, workoutExercise.id!),
              icon: const Icon(Icons.add),
              label: const Text('Add Set'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSetRow(WorkoutSet set) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: set.completed ? Colors.green : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${set.setNumber}',
                style: TextStyle(
                  color: set.completed ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text('${set.reps} reps'),
          const SizedBox(width: 16),
          Text('${set.weight} kg'),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'chest':
        return Colors.red;
      case 'back':
        return Colors.blue;
      case 'legs':
        return Colors.green;
      case 'shoulders':
        return Colors.orange;
      case 'arms':
        return Colors.purple;
      case 'core':
        return Colors.teal;
      case 'cardio':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  Future<void> _showStartWorkoutDialog(BuildContext context, WorkoutProvider provider) async {
    final TextEditingController controller = TextEditingController(text: 'Workout');

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start New Workout'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Workout Name',
            hintText: 'e.g., Chest Day, Leg Day',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Start'),
          ),
        ],
      ),
    );

    if (result == true && controller.text.isNotEmpty) {
      await provider.startWorkout(controller.text);
      setState(() {});
    }
  }

  Future<void> _showAddExerciseDialog(BuildContext context, WorkoutProvider provider) async {
    final exercise = await showDialog<Exercise>(
      context: context,
      builder: (context) => _ExercisePickerDialog(exercises: provider.exercises),
    );

    if (exercise != null && provider.currentWorkout != null) {
      await provider.addExerciseToWorkout(
        provider.currentWorkout!.id!,
        exercise.id!,
      );
      setState(() {});
    }
  }

  Future<void> _showAddSetDialog(BuildContext context, WorkoutProvider provider, int workoutExerciseId) async {
    final repsController = TextEditingController();
    final weightController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Set'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: repsController,
              decoration: const InputDecoration(
                labelText: 'Reps',
                hintText: 'e.g., 10',
              ),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(
                labelText: 'Weight (kg)',
                hintText: 'e.g., 50',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result == true) {
      final reps = int.tryParse(repsController.text) ?? 0;
      final weight = double.tryParse(weightController.text) ?? 0;

      if (reps > 0) {
        await provider.addSet(workoutExerciseId, reps, weight);
        setState(() {});
      }
    }
  }

  Future<void> _endWorkout(BuildContext context, WorkoutProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Finish Workout'),
        content: const Text('Are you sure you want to finish this workout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Finish'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await provider.endWorkout();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout finished!')),
        );
      }
    }
  }

  Future<void> _cancelWorkout(BuildContext context, WorkoutProvider provider) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Workout'),
        content: const Text('Are you sure you want to cancel this workout? All progress will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await provider.cancelWorkout();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Workout cancelled')),
        );
      }
    }
  }
}

class _ExercisePickerDialog extends StatefulWidget {
  final List<Exercise> exercises;

  const _ExercisePickerDialog({required this.exercises});

  @override
  State<_ExercisePickerDialog> createState() => _ExercisePickerDialogState();
}

class _ExercisePickerDialogState extends State<_ExercisePickerDialog> {
  String _selectedCategory = 'all';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final categories = ['all', 'chest', 'back', 'legs', 'shoulders', 'arms', 'core', 'cardio'];

    var filteredExercises = widget.exercises;
    if (_selectedCategory != 'all') {
      filteredExercises = filteredExercises.where((e) => e.category == _selectedCategory).toList();
    }
    if (_searchQuery.isNotEmpty) {
      filteredExercises = filteredExercises
          .where((e) => e.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select Exercise',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: categories.map((category) {
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(category.toUpperCase()),
                          selected: isSelected,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredExercises.length,
              itemBuilder: (context, index) {
                final exercise = filteredExercises[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(exercise.name[0].toUpperCase()),
                  ),
                  title: Text(exercise.name),
                  subtitle: Text(exercise.category.toUpperCase()),
                  onTap: () => Navigator.pop(context, exercise),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}
