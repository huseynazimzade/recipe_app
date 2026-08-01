import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/recipe_model.dart';
import '../repositories/recipe_repository.dart';
import 'recipe_detail_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({Key? key}) : super(key: key);

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final RecipeRepository _repository = RecipeRepository();
  final ScrollController _scrollController = ScrollController();

  final List<RecipeModel> _recipes = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  final List<String> _letters = ['a', 'b', 'c', 'd', 'e', 'f', 'g'];
  int _currentLetterIndex = 0;
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
      _recipes.clear();
      _currentLetterIndex = 0;
    });

    try {
      final newRecipes = await _repository.getRecipesByLetter(_letters[_currentLetterIndex]);
      setState(() {
        _recipes.addAll(newRecipes);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMoreData();
    }
  }

  Future<void> _loadMoreData() async {
    if (_isFetchingMore || _currentLetterIndex >= _letters.length - 1) return;

    setState(() => _isFetchingMore = true);

    try {
      _currentLetterIndex++;
      final moreRecipes = await _repository.getRecipesByLetter(_letters[_currentLetterIndex]);
      setState(() {
        _recipes.addAll(moreRecipes);
      });
    } catch (_) {
    } finally {
      setState(() => _isFetchingMore = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reseptlər Tətbiqi')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadInitialData,
              child: const Text('Yenidən cəhd et'),
            ),
          ],
        ),
      );
    }

    if (_recipes.isEmpty) {
      return const Center(child: Text('Heç bir resept tapılmadı.'));
    }

    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _recipes.length + (_isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == _recipes.length) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }

          final recipe = _recipes[index];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: recipe.thumbUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                errorWidget: (context, url, error) => const Icon(Icons.broken_image),
              ),
            ),
            title: Text(recipe.name),
            subtitle: Text(recipe.category),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecipeDetailScreen(recipe: recipe),
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
