import 'package:flutter/material.dart';

Widget buildCard({
  required IconData icon,
  required String title,
  required String count,
  required Color color,
}) {
  return Card(
    elevation: 6.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 30.0),
            SizedBox(height: 8.0),
            Text(
              title,
              style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8.0),
            Text(
              count,
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget buildActionCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
  required Color color,
}) {
  return Card(
    elevation: 6.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30.0),
              SizedBox(height: 8.0),
              Text(
                title,
                style: TextStyle(fontSize: 16.0, color: Colors.grey[600]),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                  minimumSize: Size(double.infinity, 40.0),
                ),
                child: Text('Créer une vague', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}