module.exports = Man = function(name, age) {
  this.name = name;
  this.age = age;
};
Man.prototype.greet = function () {
  return 'Hello, my name is ' + this.name + ', I\'m ' + this.age + ' years old';
};
