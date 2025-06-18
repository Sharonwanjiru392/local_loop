import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class CertificatesScreen extends StatelessWidget {
  const CertificatesScreen({super.key});

  static const Color themeColor = Color(0xFF5B2C6F);
  static const Color gradientEnd = Color(0xFF9B59B6);

  Future<Map<String, dynamic>?> fetchProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    return doc.data();
  }

  pw.Document generatePdf(String name, int hours) {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) => pw.Center(
          child: pw.Container(
            padding: const pw.EdgeInsets.all(32),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.deepPurple, width: 4),
            ),
            child: pw.Column(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Certificate of Appreciation',
                  style: pw.TextStyle(
                    fontSize: 32,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.deepPurple,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Awarded to', style: pw.TextStyle(fontSize: 20)),
                pw.SizedBox(height: 10),
                pw.Text(
                  name,
                  style: pw.TextStyle(fontSize: 28, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'For contributing $hours volunteer hour${hours > 1 ? 's' : ''} to the community.',
                  style: pw.TextStyle(fontSize: 18),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 40),
                pw.Text('LocalLoop Community', style: pw.TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      ),
    );
    return pdf;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Certificates'),
        backgroundColor: themeColor,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [themeColor, gradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: fetchProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final data = snapshot.data;
            if (data == null || (data['totalHours'] ?? 0) == 0) {
              return const Center(
                child: Text(
                  'No certificates earned yet.',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              );
            }

            final totalHours = data['totalHours'] ?? 0;
            final name = data['name'] ?? data['email'] ?? 'Volunteer';

            final List<int> earnedCertificates = [];
            if (totalHours >= 1) earnedCertificates.add(1);
            if (totalHours >= 20) earnedCertificates.add(20);
            if (totalHours >= 50) earnedCertificates.add(50);

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: earnedCertificates.length,
              itemBuilder: (context, index) {
                final hours = earnedCertificates[index];
                final pdf = generatePdf(name, hours);
                final fileName = 'certificate_${hours}hrs.pdf';

                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          hours == 1
                              ? '🎖️ First Hour Certificate'
                              : '🎖️ $hours+ Hours Certificate',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () async {
                                await Printing.sharePdf(
                                  bytes: await pdf.save(),
                                  filename: fileName,
                                );
                              },
                              icon: const Icon(Icons.download),
                              label: const Text('Download PDF'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Printing.layoutPdf(
                                  onLayout: (format) => pdf.save(),
                                );
                              },
                              icon: const Icon(Icons.visibility),
                              label: const Text('View'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: gradientEnd,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
