<?php
​
class CharacterGenerator {
    public static function roll(): array
    {
        $attributes = array_map(fn($stat) => self::rollStat(), range(1, 6));
​
        if (!self::meetsRequirements($attributes)) {
            return self::roll();
        }
​
        return $attributes;
    }
​
    private static function rollStat(): int
    {
        $rolls = d(6, 4);
        return array_sum($rolls) - min($rolls);
    }
​
    private static function meetsRequirements(array $attributes): bool
    {
        $twoOrMoreOverFifteen = array_reduce($attributes, fn($n, $stat) => $n + ($stat > 15)) >= 2;
        $sumOfAttributesMeetsMinimum = array_sum($attributes) >= 75;
​
        return $sumOfAttributesMeetsMinimum && $twoOrMoreOverFifteen;
    }
}
​
function d(int $d, int $numberToRoll): array
{
    return array_map(fn($roll) => rand(1, $d), range(1, $numberToRoll));
}
​
$characterAttributes = CharacterGenerator::roll();
$attributesString = implode(', ', $characterAttributes);
$attributesTotal = array_sum($characterAttributes);
​
print "Attribute Total: $attributesTotal\n";
print "Attributes: $attributesString";
