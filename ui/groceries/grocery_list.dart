import 'package:flutter/material.dart';
import '../../data/mock_grocery_repository.dart';
import '../../models/grocery.dart';
import 'grocery_form.dart';

enum GroceryTab { groceriesTab, searchTab }

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<Grocery> groceries = dummyGroceryItems;
  GroceryTab _currentTab = GroceryTab.groceriesTab;

  void onCreate() async {
    // Navigate to the form screen using the Navigator push
    Grocery? newGrocery = await Navigator.push<Grocery>(
      context,
      MaterialPageRoute(builder: (context) => const GroceryForm()),
    );
    if (newGrocery != null) {
      setState(() {
        dummyGroceryItems.add(newGrocery);
      });
    }
  }

  void handleSearch(String value) {
    setState(() {
      groceries = dummyGroceryItems.where((grocery) {
        return grocery.name.toLowerCase().startsWith(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('No items added yet.'));

    if (groceries.isNotEmpty) {
      //  Display groceries with an Item builder and  LIst Tile
      content = ListView.builder(
        itemCount: groceries.length,
        itemBuilder: (context, index) =>
            GroceryTile(grocery: groceries[index]),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [IconButton(onPressed: onCreate, icon: const Icon(Icons.add))],
      ),
      body: IndexedStack(
        index: _currentTab.index,
        children: [
          content,
          Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  onChanged: handleSearch,
                ), 
              ),           
              Expanded(child: content)
            ],
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.blue[200],
        currentIndex: _currentTab.index,
        onTap: (index) {
          setState(() {
            _currentTab = GroceryTab.values[index];
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_grocery_store), label: 'Groceries'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}

class GroceryTile extends StatelessWidget {
  const GroceryTile({super.key, required this.grocery});

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(width: 15, height: 15, color: grocery.category.color),
      title: Text(grocery.name),
      trailing: Text(grocery.quantity.toString()),
    );
  }
}
