part of activerecord;

class Config {
  DatabaseAdapter _adapter;
  Schema _schema;
  
  Config() {
    _adapter = null;
    _schema = null;
  }
  
  DatabaseAdapter get adapter => _adapter;
  Schema get schema => _schema;
}

class Schema {
  String _tableName;
  Map<String, Variable> _variables = {};
  
  Schema(this._tableName, List<Variable> vars) {
    vars.forEach((v) => _variables[v.name] = v);
  }
  
  bool hasProperty(String name) {
    return _variables.keys.contains(name);
  }
  void addVariable(Variable v) {
    _variables[v.name] = v;
  }
  void addVariables(List<Variable> vars) {
    vars.forEach((v) => addVariable(v));
  }
  toString() {
    var result = "{\n";
    _variables.forEach((_, val) => result += "\t$val\n");
    return result += "}";
  }
  
  List<Variable> get variables => new List.from(this._variables.values);
  String get tableName => _tableName;
}

class Variable {
  static var ID_FIELD = new Variable("id", VariableType.INT,
      [Constraint.PRIMARY_KEY, Constraint.AUTO_INCREMENT]);
  final String name;
  final VariableType type;
  LinkedHashSet<Constraint> _constraints;
  
  
  Variable(this.name, [this.type = VariableType.STRING, List<Constraint> constrs]) {
    constrs == null? _constraints = new LinkedHashSet() :
      _constraints = new LinkedHashSet.from(constrs);
  }
  
  toString() => "$name: $type";
  List<Constraint> get constraints =>
      _constraints == null ? [] : new List.from(_constraints);
}

class VariableType {
  static const STRING = const VariableType._(0, "String");
  static const INT = const VariableType._(1, "Integer", numerical: true);
  static const DOUBLE = const VariableType._(2, "Double", numerical: true);
  static const BOOL = const VariableType._(3, "Bool");
  static const TEXT = const VariableType._(4, "Text");
  
  final int value;
  final bool numerical;
  final String name;
  
  const VariableType._(this.value, this.name, {this.numerical : false});
  toString() => name;
}

class Constraint {
  static const NOT_NULL = const Constraint._("NOT NULL");
  static const UNIQUE = const Constraint._("UNIQUE");
  static const PRIMARY_KEY = const Constraint._("PRIMARY KEY");
  static const AUTO_INCREMENT = const Constraint._("AUTO INCREMENT");
  final String name;
  
  const Constraint._(this.name);
  toString() => name;
}