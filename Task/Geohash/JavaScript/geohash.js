const GEO_BASE_32 = "0123456789bcdefghjkmnpqrstuvwxyz";

class Range {
  constructor(lower, upper) {
    this.lower = lower;
    this.upper = upper;
  }
}

class Location {
  constructor(latitude, longitude) {
    this.latitude = latitude;
    this.longitude = longitude;
  }

  toString() {
    const sector_SN = (this.latitude < 0) ? " S" : " N";
    const sector_WE = (this.longitude < 0) ? " W" : " E";
    return `(${this.latitude}${sector_SN}, ${this.longitude}${sector_WE})`;
  }
}

function encode_geohash(location, precision) {
  let latitude_range = new Range(-90.0, 90.0);
  let longitude_range = new Range(-180.0, 180.0);
  let geohash = "";
  let geohash_value = 0;
  let bit_count = 0;
  let even = true;

  while (geohash.length < precision) {
    const value = even ? location.longitude : location.latitude;
    let range = even ? longitude_range : latitude_range;
    const midRange = (range.lower + range.upper) / 2;

    if (value > midRange) {
      geohash_value = (geohash_value << 1) + 1;
      if (even) {
        longitude_range = new Range(midRange, longitude_range.upper);
      } else {
        latitude_range = new Range(midRange, latitude_range.upper);
      }
    } else {
      geohash_value <<= 1;
      if (even) {
        longitude_range = new Range(longitude_range.lower, midRange);
      } else {
        latitude_range = new Range(latitude_range.lower, midRange);
      }
    }

    even = !even;
    if (bit_count < 4) {
      bit_count += 1;
    } else {
      bit_count = 0;
      geohash += GEO_BASE_32[geohash_value];
      geohash_value = 0;
    }
  }
  return geohash;
}

function decode_geohash(geohash) {
  let latitude_range = new Range(-90.0, 90.0);
  let longitude_range = new Range(-180.0, 180.0);
  let even = true;

  for (let i = 0; i < geohash.length; ++i) {
    const position = GEO_BASE_32.indexOf(geohash[i]);
    const binary = position.toString(2).padStart(5, '0');

    for (let j = 0; j < 5; ++j) {
      const mid_range = even
        ? (longitude_range.lower + longitude_range.upper) / 2
        : (latitude_range.lower + latitude_range.upper) / 2;

      if (binary[j] === '0') {
        if (even) {
          longitude_range = new Range(longitude_range.lower, mid_range);
        } else {
          latitude_range = new Range(latitude_range.lower, mid_range);
        }
      } else {
        if (even) {
          longitude_range = new Range(mid_range, longitude_range.upper);
        } else {
          latitude_range = new Range(mid_range, latitude_range.upper);
        }
      }
      even = !even;
    }
  }

  const latitude_error = Math.abs(latitude_range.lower - latitude_range.upper);
  const longitude_error = Math.abs(longitude_range.lower - longitude_range.upper);
  const max_error = Math.max(latitude_error, longitude_error);
  const mid_latitude = (latitude_range.lower + latitude_range.upper) / 2;
  const mid_longitude = (longitude_range.lower + longitude_range.upper) / 2;
  const sector_SN = (mid_latitude < 0) ? " S" : " N";
  const sector_WE = (mid_longitude < 0) ? " W" : " E";

  return `(${mid_latitude.toFixed(15)}${sector_SN}, ${mid_longitude.toFixed(15)}${sector_WE}) ± ${max_error}`;
}

function main() {
  const locations = [
    new Location(51.433718, -0.214126),
    new Location(51.433718, -0.214126),
    new Location(57.64911, 10.40744),
    new Location(57.64911, 10.40744)
  ];

  const precisions = [2, 9, 11, 21];
  const test_results = [];

  for (let i = 0; i < locations.length; ++i) {
    test_results.push(encode_geohash(locations[i], precisions[i]));
    console.log(`geohash for ${locations[i].toString()} with precision ${precisions[i].toString().padStart(2)} => ${test_results[test_results.length-1]}`);
  }

  console.log();

  for (const test_result of test_results) {
    console.log(`${test_result.padEnd(21)} => ${decode_geohash(test_result)}`);
  }
}

main();
