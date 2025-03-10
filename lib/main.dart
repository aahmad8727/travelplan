import 'package:flutter/material.dart';
import 'plan.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
  List<Plan> plans = [];

  // CREATE
  void addPlan(Plan plan) {
    setState(() {
      plans.add(plan);
    });
  }

  // READ is handled simply by displaying `plans` in ListView.

  // UPDATE
  void updatePlan(String id, Plan updatedPlan) {
    setState(() {
      final index = plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        plans[index] = updatedPlan;
      }
    });
  }

  // TOGGLE (pending <-> completed)
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

  // DELETE
  void removePlan(String id) {
    setState(() {
      plans.removeWhere((plan) => plan.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adoption & Travel Plans')),
      body: buildPlanList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => openCreatePlanModal(context),
      ),
    );
  }

  // Displays each Plan in a ListView
  Widget buildPlanList() {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return GestureDetector(
          onLongPress: () {
            // Edit Plan on Long Press
            openEditPlanModal(context, plan);
          },
          onDoubleTap: () {
            // Delete Plan on Double Tap
            removePlan(plan.id);
          },
          child: Dismissible(
            key: Key(plan.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              // Mark Plan as Complete/Incomplete on swipe
              togglePlanStatus(plan.id);
            },
            background: Container(
              color: Colors.green,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(Icons.check, color: Colors.white),
            ),
            child: ListTile(
              title: Text(plan.name),
              subtitle: Text(
                '${plan.description}\nDate: ${plan.date.toLocal()}',
              ),
              tileColor:
                  plan.status == PlanStatus.completed
                      ? Colors.grey[300]
                      : Colors.white,
            ),
          ),
        );
      },
    );
  }

  // CREATE Modal
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
                    decoration: InputDecoration(labelText: 'Plan Name'),
                    onChanged: (val) => name = val,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Enter a plan name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
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
                      final pickedDate = await showDatePicker(
                        context: ctx,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          selectedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Text('Create Plan'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (selectedDate == null) {
                          // If no date is chosen, show a warning
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Please select a date.')),
                          );
                          return;
                        }
                        // Create new plan
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
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // EDIT Modal
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
                    decoration: InputDecoration(labelText: 'Plan Name'),
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
                    decoration: InputDecoration(labelText: 'Description'),
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
                      final pickedDate = await showDatePicker(
                        context: ctx,
                        initialDate: updatedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2030),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          updatedDate = pickedDate;
                        });
                      }
                    },
                  ),
                  ElevatedButton(
                    child: Text('Save Changes'),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Build a new updated plan object
                        final updatedPlan = Plan(
                          id: plan.id,
                          name: updatedName,
                          description: updatedDescription,
                          date: updatedDate,
                          status: plan.status,
                        );
                        // Perform update
                        updatePlan(plan.id, updatedPlan);
                        Navigator.of(ctx).pop();
                      }
                    },
                  ),
                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
