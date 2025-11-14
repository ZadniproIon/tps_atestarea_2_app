import 'package:flutter/material.dart';

import '../models.dart';
import '../widgets/expense_list_tile.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({
    super.key,
    required this.expenses,
    required this.vehicles,
  });

  final List<CarExpense> expenses;
  final List<Vehicle> vehicles;

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  Vehicle? _selectedVehicle;

  @override
  Widget build(BuildContext context) {
    final filteredExpenses = _selectedVehicle == null
        ? widget.expenses
        : widget.expenses
            .where((e) => e.vehicleId == _selectedVehicle!.id)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: widget.expenses.isEmpty
          ? const Center(
              child: Text('No expenses yet. Tap "Add expense" to create one.'),
            )
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<Vehicle?>(
                          initialValue: _selectedVehicle,
                          decoration: const InputDecoration(
                            labelText: 'Filter by vehicle',
                          ),
                          items: [
                            const DropdownMenuItem<Vehicle?>(
                              value: null,
                              child: Text('All vehicles'),
                            ),
                            ...widget.vehicles.map(
                              (v) => DropdownMenuItem<Vehicle?>(
                                value: v,
                                child: Text(v.displayName),
                              ),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _selectedVehicle = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                if (filteredExpenses.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('No expenses for the selected vehicle.'),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredExpenses.length,
                      itemBuilder: (context, index) {
                        final expense = filteredExpenses[index];
                        final vehicle = widget.vehicles
                            .where((v) => v.id == expense.vehicleId)
                            .firstOrNull;
                        return ExpenseListTile(
                          expense: expense,
                          vehicle: vehicle,
                        );
                      },
                    ),
                  ),
              ],
            ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
