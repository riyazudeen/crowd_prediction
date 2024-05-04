GetCount getCountData(json) =>  GetCount.fromJson(json);

class GetCount {
  GetCount({
    required this.visitCounts,
  });
  late final Map<String ,dynamic> visitCounts;

  GetCount.fromJson(Map<String, dynamic> json){
    visitCounts = json['visit_counts'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['visit_counts'] = visitCounts;
    return _data;
  }
}


