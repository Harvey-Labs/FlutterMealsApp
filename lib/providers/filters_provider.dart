import 'package:flutter_riverpod/flutter_riverpod.dart';
//import meals provider
import 'package:meals/providers/meals_provider.dart';

enum Filter {
  gluten,
  lactose,
  vegan,
  vegetarian,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.gluten: false,
          Filter.lactose: false,
          Filter.vegan: false,
          Filter.vegetarian: false,
        });

  void setFilter(Filter filter, bool value) {
    state = {
      ...state,
      filter: value,
    };
  }

  void resetFilters() {
    state = {
      Filter.gluten: false,
      Filter.lactose: false,
      Filter.vegan: false,
      Filter.vegetarian: false,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) {
    return FiltersNotifier();
  },
);

final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);
  return meals.where((meal) {
    if (activeFilters[Filter.gluten] == true && !meal.isGlutenFree) {
      return false;
    }
    if (activeFilters[Filter.lactose] == true && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegan] == true && !meal.isVegan) {
      return false;
    }
    if (activeFilters[Filter.vegetarian] == true && !meal.isVegetarian) {
      return false;
    }
    return true;
  }).toList();
});
