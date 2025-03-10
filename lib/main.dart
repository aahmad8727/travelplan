import 'package:flutter/material.dart';
import 'plan.dart';

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];

  // Add a new plan
  void addPlan(Plan plan) {
    setState(() {
      plans.add(plan);
    });
  }

  // Update a plan (for editing)
  void updatePlan(String id, Plan updatedPlan) {
    setState(() {
      int index = plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        plans[index] = updatedPlan;
      }
    });
  }

  // Mark plan as completed/incomplete
  void togglePlanStatus(String id) {
    setState(() {
      int index = plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        plans[index].status = (plans[index].status == PlanStatus.pending)
            ? PlanStatus.completed
            : PlanStatus.pending;
      }
    });
  }

  // Remove a plan
  void removePlan(String id) {
    setState(() {
      plans.removeWhere((plan) => plan.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adoption & Travel Plans")),
      body: buildPlanList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openCreatePlanModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Build the list of plans
  Widget buildPlanList() {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return GestureDetector(
          onLongPress: () {
            // Open modal to edit plan details
            openEditPlanModal(context, plan);
          },
          onDoubleTap: () {
            // Delete plan on double-tap
            removePlan(plan.id);
          },
          child: Dismissible(
            key: Key(plan.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
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
                  "${plan.description}\nDate: ${plan.date.toLocal()}${plan.priority != null ? '\nPriority: ${plan.priority.toString().split('.').last}' : ''}"),
              tileColor: plan.status == PlanStatus.completed
                  ? Colors.grey[300]
                  : Colors.white,
            ),
          ),
        );
      },
    );
  }

  // Function to open a modal for creating a new plan
  void openCreatePlanModal(BuildContext context) {

  }

  // Function to open a modal for editing an existing plan
  void openEditPlanModal(BuildContext context, Plan plan) {
  }
}
import 'package:flutter/material.dart';
import 'plan.dart';

class PlanManagerScreen extends StatefulWidget {
  @override
  _PlanManagerScreenState createState() => _PlanManagerScreenState();
}

class _PlanManagerScreenState extends State<PlanManagerScreen> {
  List<Plan> plans = [];

  // Add a new plan
  void addPlan(Plan plan) {
    setState(() {
      plans.add(plan);
      // Optionally, sort plans here (e.g., by priority)
    });
  }

  // Update a plan (for editing)
  void updatePlan(String id, Plan updatedPlan) {
    setState(() {
      int index = plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        plans[index] = updatedPlan;
      }
    });
  }

  // Mark plan as completed/incomplete
  void togglePlanStatus(String id) {
    setState(() {
      int index = plans.indexWhere((plan) => plan.id == id);
      if (index != -1) {
        plans[index].status = (plans[index].status == PlanStatus.pending)
            ? PlanStatus.completed
            : PlanStatus.pending;
      }
    });
  }

  // Remove a plan
  void removePlan(String id) {
    setState(() {
      plans.removeWhere((plan) => plan.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Adoption & Travel Plans")),
      body: buildPlanList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Open modal to create a new plan
          openCreatePlanModal(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Build the list of plans
  Widget buildPlanList() {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (context, index) {
        final plan = plans[index];
        return GestureDetector(
          onLongPress: () {
            // Open modal to edit plan details
            openEditPlanModal(context, plan);
          },
          onDoubleTap: () {
            // Delete plan on double-tap
            removePlan(plan.id);
          },
          child: Dismissible(
            key: Key(plan.id),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
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
                  "${plan.description}\nDate: ${plan.date.toLocal()}${plan.priority != null ? '\nPriority: ${plan.priority.toString().split('.').last}' : ''}"),
              tileColor: plan.status == PlanStatus.completed
                  ? Colors.grey[300]
                  : Colors.white,
            ),
          ),
        );
      },
    );
  }

  // Function to open a modal for creating a new plan
  void openCreatePlanModal(BuildContext context) {
 
  }

  // Function to open a modal for editing an existing plan
  void openEditPlanModal(BuildContext context, Plan plan) {
  }
}
