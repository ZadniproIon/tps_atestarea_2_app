import 'package:flutter/material.dart';

import '../models.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({
    super.key,
    required this.vehicles,
  });

  final List<Vehicle> vehicles;

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _mileageController = TextEditingController();
  final _aiInputController = TextEditingController();

  ExpenseCategory _category = ExpenseCategory.fuel;
  Vehicle? _selectedVehicle;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.vehicles.isNotEmpty) {
      _selectedVehicle = widget.vehicles.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _mileageController.dispose();
    _aiInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add expense'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Smart input',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _aiInputController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText:
                      'Example: am cheltuit 300 lei pe benzină pentru Passat',
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: _applySmartParser,
                    icon: const Icon(Icons.bolt_outlined),
                    label: const Text('Pre-fill fields'),
                  ),
                  const SizedBox(width: 12),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Voice input is not configured in this demo build.',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.mic_none_outlined),
                    label: const Text('Voice input'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Expense details',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Amount (lei)',
                  prefixText: 'lei ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  final parsed =
                      double.tryParse(value.replaceAll(',', '.').trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid positive number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ExpenseCategory>(
                initialValue: _category,
                decoration: const InputDecoration(
                  labelText: 'Category',
                ),
                items: ExpenseCategory.values
                    .map(
                      (c) => DropdownMenuItem(
                        value: c,
                        child: Text(expenseCategoryLabel(c)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => _category = value);
                  }
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<Vehicle>(
                initialValue: _selectedVehicle,
                decoration: const InputDecoration(
                  labelText: 'Vehicle',
                ),
                items: widget.vehicles
                    .map(
                      (v) => DropdownMenuItem(
                        value: v,
                        child: Text(v.displayName),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedVehicle = value);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _mileageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mileage (km, optional)',
                  helperText:
                      'If empty, the current mileage of the vehicle is used.',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return null;
                  }
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Enter a valid mileage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(_formatDate(_selectedDate)),
                      const Icon(Icons.calendar_today_outlined),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.check),
                label: const Text('Save expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(now.year - 3),
      lastDate: DateTime(now.year + 1),
    );
    if (result != null) {
      setState(() => _selectedDate = result);
    }
  }

  void _applySmartParser() {
    final text = _aiInputController.text.toLowerCase();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please type a short description first.')),
      );
      return;
    }

    // Extract amount like "300" or "300.50".
    final amountMatch = RegExp(r'(\d+[.,]?\d*)').firstMatch(text);
    if (amountMatch != null) {
      final raw = amountMatch.group(0)!.replaceAll(',', '.');
      final amount = double.tryParse(raw);
      if (amount != null) {
        _amountController.text = amount.toStringAsFixed(0);
      }
    }

    // Very simple category detection using Romanian keywords.
    if (text.contains('benz') ||
        text.contains('motorin') ||
        text.contains('fuel')) {
      _category = ExpenseCategory.fuel;
    } else if (text.contains('service') ||
        text.contains('revizie') ||
        text.contains('garaj')) {
      _category = ExpenseCategory.service;
    } else if (text.contains('asigurare') || text.contains('rca')) {
      _category = ExpenseCategory.insurance;
    } else if (text.contains('piese') ||
        text.contains('fran') ||
        text.contains('placute')) {
      _category = ExpenseCategory.parts;
    } else {
      _category = ExpenseCategory.other;
    }

    // Try to match vehicle by model or brand name.
    for (final v in widget.vehicles) {
      final brand = v.brand.toLowerCase();
      final model = v.model.toLowerCase();
      if (text.contains(brand) || text.contains(model)) {
        _selectedVehicle = v;
        break;
      }
    }

    // Try to find mileage like "123000 km".
    final mileageMatch =
        RegExp(r'(\d{4,6})\s*km').firstMatch(text.replaceAll('.', ''));
    if (mileageMatch != null) {
      final raw = mileageMatch.group(1);
      if (raw != null) {
        _mileageController.text = raw;
      }
    }

    if (_descriptionController.text.isEmpty) {
      _descriptionController.text = _aiInputController.text;
    }

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fields pre-filled using a smart local parser.'),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vehicle.')),
      );
      return;
    }

    final amount = double.parse(
      _amountController.text.replaceAll(',', '.').trim(),
    );

    int mileage;
    if (_mileageController.text.trim().isEmpty) {
      mileage = _selectedVehicle!.mileage;
    } else {
      mileage = int.parse(_mileageController.text.trim());
    }

    final newExpense = CarExpense(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      category: _category,
      date: _selectedDate,
      description: _descriptionController.text.isEmpty
          ? 'Car expense'
          : _descriptionController.text,
      mileage: mileage,
      vehicleId: _selectedVehicle!.id,
    );

    Navigator.of(context).pop(newExpense);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year}';
  }
}

