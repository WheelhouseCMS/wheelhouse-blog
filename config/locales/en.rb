{
  :en => {
    :time => {
      :formats => {
        :blog_date => lambda { |time, _| "#{time.day.ordinalize} %b %Y" }, # 14th Apr 2013
        :blog_time => "%-I:%M %p" # 3:15 PM
      },
      :am => "AM",
      :pm => "PM"
    }
  }
}
