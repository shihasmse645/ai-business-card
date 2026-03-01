import 'package:businesscardapp/features/dashboard/dashboard_provider.dart';
import 'package:businesscardapp/features/dashboard/presentation/widgets/contact_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().loadContacts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DashboardProvider>(
      builder: (context, provider, child) {
        return RefreshIndicator(
          onRefresh: () async {
            await context.read<DashboardProvider>().loadContacts();
          },

          child: Scaffold(
            appBar: AppBar(title: const Text("Saved Contacts")),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search name or company...",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: provider.updateSearchQuery,
                  ),
                ),
                Expanded(
                  child: provider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : provider.filteredContacts.isEmpty
                      ? const Center(child: Text("No contacts yet"))
                      : ListView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemCount: provider.filteredContacts.length,
                          itemBuilder: (context, index) {
                            final contact = provider.filteredContacts[index];
                            return ContactCard(contact: contact);
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
