import 'package:flutter/material.dart';
import 'plan.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adoption & Travel Plans',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PlanManagerScreen(),
    );
  }
}

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  /// The main list of plans
  List<Plan> plans = [];

  /// CREATE
  void addPlan(Plan plan) {
    setState(() {
      plans.add(plan);
    });
  }

  /// UPDATE
  void updatePlan(String id, Plan updatedPlan) {
    setState(() {
      final index = plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        plans[index] = updatedPlan;
      }
    });
  }

  /// TOGGLE STATUS
  void togglePlanStatus(String id) {
    setState(() {
      final index = plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        plans[index].status =
            (plans[index].status == PlanStatus.pending)
                ? PlanStatus.completed
                : PlanStatus.pending;
      }
    });
  }

  /// DELETE
  void removePlan(String id) {
    setState(() {
      plans.removeWhere((plan) => plan.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adoption & Travel Plans')),
      body: buildPlanList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openCreatePlanModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Displays the plans in a ListView
  Widget buildPlanList() {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return GestureDetector(
          onLongPress:
              () => openEditPlanModal(context, plan), // long press to edit
          onDoubleTap: () => removePlan(plan.id), // double tap to delete
          child: Dismissible(
            key: Key(plan.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              togglePlanStatus(plan.id);
            },
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: const Icon(Icons.check, color: Colors.white),
            ),
            child: ListTile(
              tileColor:
                  plan.status == PlanStatus.completed
                      ? Colors.grey[300]
                      : Colors.white,
              title: Text(plan.name),
              subtitle: Text(
                '${plan.description}\nDate: ${plan.date.toLocal()}',
              ),
            ),
          ),
        );
      },
    );
  }

  /// Bottom sheet to CREATE a new plan
  void openCreatePlanModal(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    String name = '';
    String description = '';
    DateTime? selectedDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Plan Name'),
                    onChanged: (val) => name = val,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a plan name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (val) => description = val,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a description';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    child: Text(
                      selectedDate == null
                          ? 'Select Date'
                          : 'Date: ${selectedDate!.toLocal()}',
                    ),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Create Plan'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please select a date'),
                            ),
                          );
                          return;
                        }
                        final newPlan = Plan(
                          id: DateTime.now().toString(),
                          name: name,
                          description: description,
                          date: selectedDate!,
                        );
                        addPlan(newPlan);
                        Navigator.of(ctx).pop();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ///EDIT an existing plan
  void openEditPlanModal(BuildContext context, Plan plan) {
    final _formKey = GlobalKey<FormState>();
    String updatedName = plan.name;
    String updatedDescription = plan.description;
    DateTime updatedDate = plan.date;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    initialValue: updatedName,
                    decoration: const InputDecoration(labelText: 'Plan Name'),
                    onChanged: (val) => updatedName = val,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a plan name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: updatedDescription,
                    decoration: const InputDecoration(labelText: 'Description'),
                    onChanged: (val) => updatedDescription = val,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a description';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    child: Text('Date: ${updatedDate.toLocal()}'),
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: ctx,
                        initialDate: updatedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (picked != null) {
                        setState(() {
                          updatedDate = picked;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    child: const Text('Save Changes'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final updatedPlan = Plan(
                          id: plan.id,
                          name: updatedName,
                          description: updatedDescription,
                          date: updatedDate,
                          status: plan.status,
                        );
                        updatePlan(plan.id, updatedPlan);
                        Navigator.of(ctx).pop();
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
