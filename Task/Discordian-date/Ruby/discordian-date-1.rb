require 'date'

class DiscordianDate
  SEASON_NAMES = ["Chaos","Discord","Confusion","Bureaucracy","The Aftermath"]
  DAY_NAMES = ["Sweetmorn","Boomtime","Pungenday","Prickle-Prickle","Setting Orange"]
  YEAR_OFFSET = 1166
  DAYS_PER_SEASON = 73
  DAYS_PER_WEEK = 5
  ST_TIBS_DAY_OF_YEAR = 60

  def initialize(year, month, day)
    gregorian_date = Date.new(year, month, day)
    @day_of_year = gregorian_date.yday

    @st_tibs = false
    if gregorian_date.leap?
      if @day_of_year == ST_TIBS_DAY_OF_YEAR
        @st_tibs = true
      elsif @day_of_year > ST_TIBS_DAY_OF_YEAR
        @day_of_year -= 1
      end
    end

    @season, @day = @day_of_year.divmod(DAYS_PER_SEASON)
    @year = gregorian_date.year + YEAR_OFFSET
  end
  attr_reader :year, :day

  def season
    SEASON_NAMES[@season]
  end

  def weekday
    if @st_tibs
      "St. Tib's Day"
    else
      DAY_NAMES[(@day_of_year - 1) % DAYS_PER_WEEK]
    end
  end

  def to_s
    %Q{#{@st_tibs ? "St. Tib's Day" : "%s, %s %d" % [weekday, season, day]}, #{year} YOLD}
  end
end
