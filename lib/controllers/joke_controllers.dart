import 'dart:async';

import 'package:get/get.dart';
import 'package:joke_app/models/joke.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JokeController extends GetxController {
  var jokes = <Joke>[].obs;
  var isLoading = false.obs;

  Timer? _fetchTimer;

  @override
  void onInit() {
    super.onInit();
    _loadJokes();
    _startFetchTimer();
    fetchJokeWithLoading();
  }

  @override
  void onClose() {
    super.onClose();
    _cancelFetchTimer();
  }

  void _startFetchTimer() {
    _fetchTimer = Timer.periodic(Duration(minutes: 1), (_) {
      fetchJokeWithLoading();
    });
  }

  void _cancelFetchTimer() {
    _fetchTimer?.cancel();
  }

  Future<void> fetchJokeWithLoading() async {
    isLoading.value = true;
    try {
      final jokeText = await fetchJokeFromApi();
      var newJoke = Joke(jokeText, isLoading: true);
      jokes.insert(0, newJoke);
      if (jokes.length > 10) {
        jokes.removeLast();
      }
      newJoke.isLoading = false;
      await _saveJokes(jokes);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _saveJokes(List<Joke> jokes) async {
    final prefs = await SharedPreferences.getInstance();
    final jokesList = jokes.map((joke) => joke.text).toList();
    await prefs.setStringList('jokes', jokesList);
  }

  Future<void> _loadJokes() async {
    final prefs = await SharedPreferences.getInstance();
    final jokesList = prefs.getStringList('jokes');
    if (jokesList != null) {
      jokes.value = jokesList.map((jokeText) => Joke(jokeText)).toList().obs;
    }
  }

  Future<String> fetchJokeFromApi() async {
    final response = await http.get(
        Uri.parse('https://geek-jokes.sameerkumar.website/api?format=json'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['joke'];
    }
    return '';
  }
}
