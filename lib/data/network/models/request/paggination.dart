class Pagination {
  final int _allCount;
  int _page;

  int get allCount => _allCount;

  int get page => _page;

  Pagination({
    allCount = 0,
    page = 1,
  })  : _allCount = allCount,
        _page = page;

  ///return false if we already get all elements, or true if we can LoadMore
  bool incrementPage() {
    if (page > _allCount) {
      return false;
    }
    _page++;
    return true;
  }

  void decrementPage() {
    _page--;
  }
}
