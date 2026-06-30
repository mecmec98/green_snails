import '../models/review.dart';
import 'api_client.dart';

class ReviewService {
  final ApiClient _api = ApiClient();

  Future<List<Review>> getReviews(String recipeId) async {
    final response = await _api.get('/recipes/$recipeId/reviews');
    return (response['reviews'] as List).map((r) => Review.fromJson(r)).toList();
  }

  Future<Review> createReview(String recipeId, int rating, String? comment) async {
    final response = await _api.post('/recipes/$recipeId/reviews', body: {
      'rating': rating,
      if (comment != null) 'comment': comment,
    });
    return Review.fromJson(response['review']);
  }

  Future<Review> updateReview(String id, {int? rating, String? comment}) async {
    final body = <String, dynamic>{};
    if (rating != null) body['rating'] = rating;
    if (comment != null) body['comment'] = comment;

    final response = await _api.put('/reviews/$id', body: body);
    return Review.fromJson(response['review']);
  }

  Future<void> deleteReview(String id) async {
    await _api.delete('/reviews/$id');
  }
}
