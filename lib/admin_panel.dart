import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Developer Requests"),
        backgroundColor: const Color(0xFF123B5A),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("requests")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          if (requests.isEmpty) {
            return const Center(
              child: Text("No requests yet"),
            );
          }

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {

              final data = requests[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        "Name: ${data["name"]}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      const SizedBox(height: 5),

                      Text("Contact: ${data["contact"]}"),

                      const SizedBox(height: 5),

                      Text("Category: ${data["category"]}"),

                      const SizedBox(height: 10),

                      Text("Description:\n${data["description"]}"),

                      const SizedBox(height: 10),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          Text(
                            "Status: ${data["status"]}",
                            style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Row(
                            children: [

                              IconButton(
                                icon: const Icon(Icons.check, color: Colors.green),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("requests")
                                      .doc(data.id)
                                      .update({"status": "accepted"});
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection("requests")
                                      .doc(data.id)
                                      .update({"status": "rejected"});
                                },
                              ),

                            ],
                          )

                        ],
                      )

                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}