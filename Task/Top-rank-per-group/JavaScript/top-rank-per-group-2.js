var collectDept = function (arrOfObj) {
  var collect = arrOfObj.reduce(function (rtnObj, obj) {
    if (rtnObj[obj.dept] === undefined) {
      rtnObj[obj.dept] = [];
    }
    rtnObj[obj.dept].push(obj);
    return rtnObj;
  }, {});

  return Object.keys(collect).map(function (key) {
    return collect[key];
  });
};

var sortSalary = function (arrOfSalaryArrs) {
  return arrOfSalaryArrs.map(function (item) {
    return item.sort(function (a, b) {
      if (a.salary > b.salary) { return -1; }
      if (a.salary < b.salary) { return 1; }
      return 0;
    });
  });
};

var getNTopSalariesByDept = function (n, data) {
  if (n < 0) { return; }

  return sortSalary(collectDept(data)).map(function (list) {
    return list.slice(0,n);
  });
};
