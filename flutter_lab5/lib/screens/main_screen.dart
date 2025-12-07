import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/main_screen_cubit.dart';
import 'cubit/main_screen_state.dart';
import 'history_screen.dart';
import 'result_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final TextEditingController massController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();
  bool _controllersInitialized = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenCubit, MainScreenState>(
      listener: (context, state) {
        _initializeControllers(state);
      },
      builder: (context, state) {
        if (state is MainScreenCalculation) {
          return ResultScreen(
            mass: state.mass!,
            radius: state.radius!,
            velocityMs: state.cosmicVelocity!,
            onNewCalculation: _resetAndGoBack,
          );
        }

        return _buildMainScreen(context, state);
      },
    );
  }

  void _initializeControllers(MainScreenState state) {
    if (!_controllersInitialized) {
      if (state.mass != null && massController.text.isEmpty) {
        massController.text = state.mass!;
      }
      if (state.radius != null && radiusController.text.isEmpty) {
        radiusController.text = state.radius!;
      }
      _controllersInitialized = true;
    }
  }

  void _resetAndGoBack() {
    context.read<MainScreenCubit>().reset();
    massController.clear();
    radiusController.clear();
    _controllersInitialized = false;
  }

  Widget _buildMainScreen(BuildContext context, MainScreenState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор космической скорости'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _buildContent(context, state),
    );
  }

  Widget _buildContent(BuildContext context, MainScreenState state) {
    if (state is MainScreenLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: massController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Масса планеты (кг)',
              border: const OutlineInputBorder(),
              errorText: state.massError,
            ),
            onChanged: (value) {
              context.read<MainScreenCubit>().updateMass(value);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: radiusController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Радиус планеты (м)',
              border: const OutlineInputBorder(),
              errorText: state.radiusError,
            ),
            onChanged: (value) {
              context.read<MainScreenCubit>().updateRadius(value);
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Checkbox(
                value: state.isAgreed,
                onChanged: (value) {
                  context.read<MainScreenCubit>().updateAgreement(value ?? false);
                },
              ),
              const Text('Согласен на обработку данных'),
            ],
          ),
          if (state is MainScreenError)
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.all(12),
              color: Colors.red[100],
              child: Text(
                state.errorMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: state.mass != null && 
                      state.radius != null &&
                      state.mass!.isNotEmpty &&
                      state.radius!.isNotEmpty &&
                      state.isAgreed &&
                      state.massError == null &&
                      state.radiusError == null
                ? () {
                    context.read<MainScreenCubit>().calculateCosmicVelocity();
                  }
                : null,
            child: const Text('Рассчитать'),
          ),
        ],
      ),
    );
  }
}