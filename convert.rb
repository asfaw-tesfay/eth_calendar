require 'date'
module CalendarsHelper
  # Returns ethiopian calendar equivalent of a date
  # in a hash (year, month and day).  
  #   Date.new(2005, 4, 25).to_ethd  #{:year=>1997, :month=>8, :day=>17}
  def to_ethiopian_hash (db_date)
    jd = db_date.jd

    # the following is the number of days since Meskerem 1 4721ዓ/ዓ
    jd += 124

    four_years = 365 * 4 + 1
    four_years_rem = jd % four_years
    days_rem = four_years_rem % 365
    remaining_years = four_years_rem / 365
    if remaining_years == 4
      remaining_years = 3
      days_rem = 365
    end

    year = -4720 + Integer(jd / four_years) * 4 + remaining_years
    month = Integer(days_rem / 30) + 1
    days_rem %= 30
    day = days_rem + 1

    {year: year, month: month, day: day}
  end

  # Converts ethiopian calendar and returns a Date
  # :call-seq: Date.new.to_ethd(2005, 4, 25 -> Date
  # [+cat+]
  #   Date.new.ethd(2005, 4, 25)  #<Date: 2013-01-03 ((2456296j,0s,0n),+0s,2299161j)>
  def to_gregorian(ethiopian)
    ethiopian = ethiopian.split('-')
    ethiopian = ethiopian.each.map(&:to_i)
    ethiopian[2] += 4720
    four_years_count = Integer(@ethiopian[2] / 4)
    remaining_years = ethiopian[2] % 4

    if ethiopian[2].to_i > 0 and ethiopian[1].to_i > 0 and ethiopian[1].to_i < 14 and
                ethiopian[0] > 0 and ethiopian[0] < 31
      jd = four_years_count * (365 * 4 + 1) + remaining_years * 365 + (@ethiopian[1] - 1) * 30 + @ethiopian[0] - 125
      Date.jd(jd)
    else
      Date.jd(0)
    end
  end

  def to_ethiopian(db_date)
    ethiopian = to_ethiopian_hash( Date.new(db_date.strftime("%Y").to_i,
          db_date.strftime("%m").to_i, db_date.strftime("%d").to_i))
    ethiopian[:day].to_s+'-'+@ethiopian[:month].to_s+'-'+@ethiopian[:year].to_s   
  end

  def is_date?(string_date)
    begin
      to_ethiopian(string_date)
      return true
    rescue
      return false
    end
  end
end
