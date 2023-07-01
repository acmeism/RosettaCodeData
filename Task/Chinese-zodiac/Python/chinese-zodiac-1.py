# coding: utf-8

from __future__ import print_function
from datetime import datetime

pinyin = {
  '甲': 'jiă',
  '乙': 'yĭ',
  '丙': 'bĭng',
  '丁': 'dīng',
  '戊': 'wù',
  '己': 'jĭ',
  '庚': 'gēng',
  '辛': 'xīn',
  '壬': 'rén',
  '癸': 'gŭi',

  '子': 'zĭ',
  '丑': 'chŏu',
  '寅': 'yín',
  '卯': 'măo',
  '辰': 'chén',
  '巳': 'sì',
  '午': 'wŭ',
  '未': 'wèi',
  '申': 'shēn',
  '酉': 'yŏu',
  '戌': 'xū',
  '亥': 'hài'
}

animals = ['Rat', 'Ox', 'Tiger', 'Rabbit', 'Dragon', 'Snake',
           'Horse', 'Goat', 'Monkey', 'Rooster', 'Dog', 'Pig']
elements = ['Wood', 'Fire', 'Earth', 'Metal', 'Water']

celestial = ['甲', '乙', '丙', '丁', '戊', '己', '庚', '辛', '壬', '癸']
terrestrial = ['子', '丑', '寅', '卯', '辰', '巳', '午', '未', '申', '酉', '戌', '亥']
aspects = ['yang', 'yin']


def calculate(year):
    BASE = 4
    year = int(year)
    cycle_year = year - BASE
    stem_number = cycle_year % 10
    stem_han = celestial[stem_number]
    stem_pinyin = pinyin[stem_han]
    element_number = stem_number // 2
    element = elements[element_number]
    branch_number = cycle_year % 12
    branch_han = terrestrial[branch_number]
    branch_pinyin = pinyin[branch_han]
    animal = animals[branch_number]
    aspect_number = cycle_year % 2
    aspect = aspects[aspect_number]
    index = cycle_year % 60 + 1
    print("{}: {}{} ({}-{}, {} {}; {} - year {} of the cycle)"
          .format(year, stem_han, branch_han,
                  stem_pinyin, branch_pinyin, element, animal, aspect, index))


current_year = datetime.now().year
years = [1935, 1938, 1968, 1972, 1976, current_year]
for year in years:
    calculate(year)
