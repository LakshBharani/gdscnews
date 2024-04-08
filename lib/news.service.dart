import 'dart:convert';
import 'package:gdscnews/api.config.dart';
import 'package:http/http.dart' as http;

// get top news
Future fetchTopNews() async {
  final response =
      await http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.topStories}'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch top news');
  }
}

// get new news
Future fetchNewNews() async {
  final response =
      await http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.newStories}'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch new news');
  }
}

// get best news
Future fetchBestNews() async {
  final response =
      await http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.bestStories}'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch best news');
  }
}

// get news by id
Future fetchNewsById(int id) async {
  final response = await http
      .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.item}$id.json'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch news');
  }
}

// get user by id
Future fetchUserById(String id) async {
  final response = await http
      .get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.user}$id.json'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch user');
  }
}

// get max item
Future fetchMaxItem() async {
  final response =
      await http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.maxItem}'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data;
  } else {
    throw Exception('Failed to fetch max item');
  }
}

// get news by id
Future fetchNewsByIds(List<int> ids) async {
  final List<Future> futures = [];
  for (int id in ids) {
    futures.add(fetchNewsById(id));
  }
  return Future.wait(futures);
}

// get user by id
Future fetchUserByIds(List<String> ids) async {
  final List<Future> futures = [];
  for (String id in ids) {
    futures.add(fetchUserById(id));
  }
  return Future.wait(futures);
}

// get top news with limit
Future fetchTopNewsWithLimit(int limit) async {
  final response =
      await http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.topStories}'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body).sublist(0, limit);
    return data;
  } else {
    throw Exception('Failed to fetch top news');
  }
}

// get new news with limit
Future fetchNewNewsWithLimit(int limit) async {
  final response =
      await http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.newStories}'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body).sublist(0, limit);
    return data;
  } else {
    throw Exception('Failed to fetch new news');
  }
}

// get best news with limit
Future fetchBestNewsWithLimit(int limit) async {
  final response =
      await http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.bestStories}'));
  if (response.statusCode == 200) {
    final data = json.decode(response.body).sublist(0, limit);
    return data;
  } else {
    throw Exception('Failed to fetch best news');
  }
}
