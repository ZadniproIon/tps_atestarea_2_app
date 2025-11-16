import 'package:flutter/material.dart';

import '../models.dart';
import '../widgets/category_chart.dart';
import '../widgets/expense_list_tile.dart';
import '../widgets/summary_card.dart';

class VehicleDetailScreen extends StatelessWidget {
  const VehicleDetailScreen({
    super.key,
    required this.vehicle,
    required this.expenses,
    required this.reminders,
  });

  final Vehicle vehicle;
  final List<CarExpense> expenses;
  final List<MaintenanceReminder> reminders;

  @override
  Widget build(BuildContext context) {
    final vehicleExpenses =
        expenses.where((e) => e.vehicleId == vehicle.id).toList();
    final vehicleReminders =
        reminders.where((r) => r.vehicleId == vehicle.id).toList();

    final totalSpent = vehicleExpenses.fold<double>(
      0,
      (sum, e) => sum + e.amount,
    );

    vehicleExpenses.sort((a, b) => b.date.compareTo(a.date));
    final lastExpense =
        vehicleExpenses.isNotEmpty ? vehicleExpenses.first : null;

    final categoryTotals = <ExpenseCategory, double>{};
    for (final e in vehicleExpenses) {
      categoryTotals[e.category] =
          (categoryTotals[e.category] ?? 0) + e.amount;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${vehicle.displayName} · ${vehicle.year}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: SummaryCard(
                    title: 'Total spent',
                    value: '${totalSpent.toStringAsFixed(0)} lei',
                    subtitle: '${vehicleExpenses.length} expenses',
                    icon: Icons.payments_outlined,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SummaryCard(
                    title: 'Current mileage',
                    value: '${vehicle.mileage} km',
                    subtitle: lastExpense == null
                        ? 'No history yet'
                        : 'Last at ${lastExpense.mileage} km',
                    icon: Icons.speed,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CategoryChart(categoryTotals: categoryTotals),
            const SizedBox(height: 16),
            Text(
              'Maintenance for this vehicle',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (vehicleReminders.isEmpty)
              const Text('No maintenance reminders set.')
            else
              _VehicleMaintenanceList(reminders: vehicleReminders),
            const SizedBox(height: 16),
            Text(
              'Expense history',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (vehicleExpenses.isEmpty)
              const Text('No expenses recorded for this vehicle yet.')
            else
              Column(
                children: vehicleExpenses
                    .map(
                      (e) => ExpenseListTile(
                        expense: e,
                        vehicle: vehicle,
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _VehicleMaintenanceList extends StatelessWidget {
  const _VehicleMaintenanceList({
    required this.reminders,
  });

  final List<MaintenanceReminder> reminders;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      children: reminders.map((r) {
        final dueInfo = _buildDueInfo(r);
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(Icons.build_circle_outlined, color: scheme.primary),
            title: Text(r.title),
            subtitle: Text('$dueInfo\n${r.description}'),
            isThreeLine: true,
          ),
        );
      }).toList(),
    );
  }

  String _buildDueInfo(MaintenanceReminder reminder) {
    if (reminder.dueDate != null) {
      final date = reminder.dueDate!;
      return 'Due on ${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';
    }
    if (reminder.dueMileage != null) {
      return 'Due at ${reminder.dueMileage} km';
    }
    return 'No due information';
  }
}

