import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/main_screen_cubit.dart';
import 'cubit/main_screen_state.dart';

class MainScreen extends StatelessWidget {
  final TextEditingController massController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MainScreenCubit, MainScreenState>(
      listener: (context, state) {
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Калькулятор первой космической скорости'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildContent(context, state),
          ),
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, MainScreenState state) {
    if (state is MainScreenLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is MainScreenCalculation) {
      return _buildResultScreen(context, state);
    }

    return _buildInputScreen(context, state);
  }

  Widget _buildInputScreen(BuildContext context, MainScreenState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 10),
        
        TextField(
          controller: massController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Масса небесного тела (кг)',
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
            labelText: 'Радиус небесного тела (м)',
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

        const SizedBox(height: 10),

        if (state is MainScreenError)
          Container(
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

        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildResultScreen(BuildContext context, MainScreenCalculation state) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Первая космическая скорость:',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 10),
        
        Text(
          '${state.cosmicVelocity!.toStringAsFixed(2)} м/с',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 10),
        
        Text(
          '${(state.cosmicVelocity! / 1000).toStringAsFixed(2)} км/с',
          style: const TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        
        const SizedBox(height: 30),
        
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Исходные данные:',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Масса: ${state.mass} кг',
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Радиус: ${state.radius} м',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 30),
        
        ElevatedButton(
          onPressed: () {
            context.read<MainScreenCubit>().reset();
            massController.clear();
            radiusController.clear();
          },
          child: const Text('Новый расчет'),
        ),
      ],
    ),
  );
}
}