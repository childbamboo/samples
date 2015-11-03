#!/usr/bin/env node
/**
* hello-nodejs-command.js
*/
Rx = require('rx');
fs = require('fs');

observable = Rx.Observable.create(function(obs) {
  fs.readFile("hoge.txt", function(err, text) {
    if (err) {
      obs.onError(err);
      return;
    }
    text.toString().split("\n").forEach(function(line) {
      obs.onNext(line);
    });
    obs.onCompleted();
  });
});

observable.filter(function(line){
  return line.substr(0, 2) != '# ';
}).subscribe(function(line){
  console.log(line);
});
