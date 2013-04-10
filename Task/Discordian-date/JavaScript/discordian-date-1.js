/**
 * All Hail Discordia! - this script prints Discordian date using system date.
 * author: s1w_, lang: JavaScript
 */
function print_ddate(mod) {
  var p;
  switch(mod || 0) {// <--choose display pattern or pass option by parameter
   default:
    case 0:/* Sweetmorn, Day 57 of the Season of Confusion, Anno Mung 3177 */ p="{0}, [Day {1} of the Season of {2}], Anno Mung {3}"; break;
    case 1:/* Sweetmorn, The 57th Day of Confusion, 3177 YOLD              */ p="{0}, [The {1}th Day of {2}], {3} YOLD";              break;
    case 2:/* Sweetmorn, the 57th day of Confusion, AM 3177                */ p="{0}, [the {1}th day of {2}], AM {3}";                break;
    case 3:/* Sweetmorn / Confusion 57th / AM 3177                         */ p="{0} / [{2} {1}th] / AM {3}";                         break;
  }
  var ddateStr, curr, sum, extra, today, day, month, year, dSeason, dDay, season, ddate, dyear;

  format = function(s, $1, $2, $3, $4) {
    if ($2 != undefined) {
      var postfix;
      switch(parseInt($2.charAt($2.length-1))) {
        case 1: postfix = '}st'; break;
        case 2: postfix = '}nd'; break;
        case 3: postfix = '}rd'; break;
        default:postfix = '}th';
      }
      return p.replace(/\}th/, postfix).replace(/(\[|\])/g, '').format($1, $2, $3, $4);
    }
    else return p.replace(/\[.*?\]/,"<span style='color:green'>{2}</span>").format($1, $2, $3, $4);
  }

  String.prototype.format = function() {
    var pattern = /\{\d+\}/g;
    var args = arguments;
    return this.replace(pattern, function(capture){ return args[capture.match(/\d+/)]; });
  }

  dDay = new Array("Sweetmorn", "Boomtime", "Pungenday", "Prickle-Prickle", "Setting Orange");
  dSeason = new Array("Chaos", "Discord", "Confusion", "Bureaucracy", "Aftermath");
  curr = new Date(); extra = new Array(0,3,0,3,2,3,2,3,3,2,3,2);
  today = curr.getDate(); month = curr.getMonth(); year = curr.getFullYear();
  sum = month * 28;
  for(var i=0; i<=month; i++)
    sum += extra[i];
  sum += today;
  day = (sum - 1) % 5; ddate = sum % 73;
  season = (month==1)&&(today==29) ? "St. Tib\'s Day" : dSeason[Math.floor(sum/73)];
  dyear = year+1166;
  ddateStr = ""+dDay[day]+ddate+season+dyear;
  document.write(ddateStr.replace(/(\D+)(?:(\d+)(?!St)|(?:\d+))(\D+)(\d+)/i, format));
}
