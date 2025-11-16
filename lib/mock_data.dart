import 'models.dart';

final List<Vehicle> mockVehicles = [
  const Vehicle(
    id: 'v1',
    brand: 'Volkswagen',
    model: 'Passat',
    year: 2018,
    engine: '2.0 TDI',
    vin: 'WVWZZZ3CZJE000001',
    mileage: 168000,
  ),
  const Vehicle(
    id: 'v2',
    brand: 'Tesla',
    model: 'Model 3',
    year: 2022,
    engine: 'Long Range',
    vin: '5YJ3E1EA7KF000003',
    mileage: 24000,
  ),
  const Vehicle(
    id: 'v3',
    brand: 'Porsche',
    model: 'Cayenne',
    year: 2023,
    engine: '3.0 Hybrid',
    vin: 'WP1ZZZ9YZPA000004',
    mileage: 22000,
  ),
];

final List<CarExpense> mockExpenses = [
  // Passat
  CarExpense(
    id: 'e1',
    amount: 320,
    category: ExpenseCategory.fuel,
    date: DateTime.now().subtract(const Duration(days: 2)),
    description: 'Diesel - full tank (OMV)',
    mileage: 168200,
    vehicleId: 'v1',
  ),
  CarExpense(
    id: 'e2',
    amount: 1450,
    category: ExpenseCategory.service,
    date: DateTime.now().subtract(const Duration(days: 18)),
    description: 'Major service + timing belt kit',
    mileage: 167500,
    vehicleId: 'v1',
  ),
  CarExpense(
    id: 'e3',
    amount: 780,
    category: ExpenseCategory.insurance,
    date: DateTime.now().subtract(const Duration(days: 40)),
    description: 'RCA + roadside assistance',
    mileage: 166000,
    vehicleId: 'v1',
  ),

  // Tesla Model 3
  CarExpense(
    id: 'e4',
    amount: 120,
    category: ExpenseCategory.fuel,
    date: DateTime.now().subtract(const Duration(days: 1)),
    description: 'Fast charging on highway (Supercharger)',
    mileage: 24150,
    vehicleId: 'v2',
  ),
  CarExpense(
    id: 'e5',
    amount: 450,
    category: ExpenseCategory.service,
    date: DateTime.now().subtract(const Duration(days: 14)),
    description: 'Tire rotation + brake check',
    mileage: 23500,
    vehicleId: 'v2',
  ),
  CarExpense(
    id: 'e6',
    amount: 1600,
    category: ExpenseCategory.insurance,
    date: DateTime.now().subtract(const Duration(days: 55)),
    description: 'Full insurance (CASCO)',
    mileage: 22000,
    vehicleId: 'v2',
  ),

  // Porsche Cayenne
  CarExpense(
    id: 'e7',
    amount: 460,
    category: ExpenseCategory.fuel,
    date: DateTime.now().subtract(const Duration(days: 3)),
    description: 'Petrol + charge (hybrid)',
    mileage: 22250,
    vehicleId: 'v3',
  ),
  CarExpense(
    id: 'e8',
    amount: 2250,
    category: ExpenseCategory.service,
    date: DateTime.now().subtract(const Duration(days: 25)),
    description: 'First inspection at Porsche Center',
    mileage: 21000,
    vehicleId: 'v3',
  ),
  CarExpense(
    id: 'e9',
    amount: 1850,
    category: ExpenseCategory.parts,
    date: DateTime.now().subtract(const Duration(days: 45)),
    description: 'Winter tires set',
    mileage: 19500,
    vehicleId: 'v3',
  ),
  CarExpense(
    id: 'e10',
    amount: 260,
    category: ExpenseCategory.other,
    date: DateTime.now().subtract(const Duration(days: 7)),
    description: 'Premium wash & detailing',
    mileage: 22300,
    vehicleId: 'v3',
  ),
];

final List<MaintenanceReminder> mockReminders = [
  MaintenanceReminder(
    id: 'm1',
    title: 'Oil change',
    description: 'Recommended every 15.000 km or 12 months.',
    dueMileage: 180000,
    vehicleId: 'v1',
  ),
  MaintenanceReminder(
    id: 'm2',
    title: 'ITP (Romanian inspection)',
    description: 'Next technical inspection for Passat.',
    dueDate: DateTime.now().add(const Duration(days: 90)),
    vehicleId: 'v1',
  ),
  MaintenanceReminder(
    id: 'm3',
    title: 'Tire rotation',
    description: 'Rotate tires and check alignment.',
    dueMileage: 26000,
    vehicleId: 'v2',
  ),
  MaintenanceReminder(
    id: 'm4',
    title: 'Hybrid system check',
    description: 'Check high-voltage battery and cooling system.',
    dueDate: DateTime.now().add(const Duration(days: 120)),
    vehicleId: 'v3',
  ),
];
