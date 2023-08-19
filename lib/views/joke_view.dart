import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:joke_app/controllers/joke_controllers.dart';
import 'package:joke_app/models/joke.dart';

class JokeView extends StatelessWidget {
  final JokeController _jokeController = Get.put(JokeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Geek Jokes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Obx(() {
        final jokes = _jokeController.jokes;
        return Column(
          children: [
            if (_jokeController.isLoading.value)
              LinearProgressIndicator(
                backgroundColor: Colors.indigo,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: jokes.length,
                itemBuilder: (context, index) {
                  return _buildAnimatedListItem(index, jokes[index]);
                },
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _jokeController.fetchJokeWithLoading();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.indigo,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildAnimatedListItem(int index, Joke joke) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          joke.text,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
