import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Developer Requests", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2A0845), Color(0xFF6441A5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("requests")
                .orderBy("time", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator(color: Colors.purpleAccent));
              }

              final requests = snapshot.data!.docs;

              if (requests.isEmpty) {
                return Center(
                  child: Text("No requests yet 📭", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18)),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final data = requests[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    data["name"],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: data["status"] == "accepted"
                                          ? Colors.greenAccent.withOpacity(0.2)
                                          : data["status"] == "rejected"
                                          ? Colors.redAccent.withOpacity(0.2)
                                          : Colors.orangeAccent.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: data["status"] == "accepted" ? Colors.greenAccent : data["status"] == "rejected" ? Colors.redAccent : Colors.orangeAccent,
                                      ),
                                    ),
                                    child: Text(
                                      data["status"].toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: data["status"] == "accepted" ? Colors.greenAccent : data["status"] == "rejected" ? Colors.redAccent : Colors.orangeAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text("📞 ${data["contact"]}", style: TextStyle(color: Colors.white.withOpacity(0.8))),
                              const SizedBox(height: 5),
                              Text("📁 ${data["category"]}", style: TextStyle(color: Colors.white.withOpacity(0.8))),
                              const SizedBox(height: 10),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: Colors.black.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                                child: Text(data["description"], style: const TextStyle(color: Colors.white)),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 30),
                                    onPressed: () {
                                      FirebaseFirestore.instance.collection("requests").doc(data.id).update({"status": "accepted"});
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.cancel_outlined, color: Colors.redAccent, size: 30),
                                    onPressed: () {
                                      FirebaseFirestore.instance.collection("requests").doc(data.id).update({"status": "rejected"});
                                    },
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}