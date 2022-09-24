import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/providers/quiz_app_provider.dart';
import 'package:quiz_app/util/constants.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<QuizAppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      backgroundColor: COLOR_BEIGE,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                'THE TOP 10 SCORES!',
                style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: COLOR_BROWN),
              ),
              const Divider(
                thickness: 3,
              ),
              Expanded(
                child: ListView.separated(
                  itemCount: provider.topTen.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        provider.topTen[index]['name'] ?? 'NAME_MISSING',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: COLOR_LIGHT_BROWN),
                      ),
                      subtitle: Text(
                        provider.topTen[index]['score'].toString(),
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: COLOR_BROWN),
                      ),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
