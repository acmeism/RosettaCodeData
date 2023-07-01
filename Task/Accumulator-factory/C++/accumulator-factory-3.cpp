struct CumulantBase_
{
   virtual ~CumulantBase_();
   virtual std::ostream& Write(std::ostream& dst) const = 0;
};

template<class T_> struct Cumulant_ : CumulantBase_
{
   T_ val_;
   Cumulant_(const T_& val) : val_(val) {}
   std::ostream& Write(std::ostream& dst) const override
   {
      return dst << val_;
   }
};

struct Accumulator_
{
   std::unique_ptr<CumulantBase_> val_;
   template<class T_> Accumulator_(const T_& val) { Set(val); }
   template<class T_> void Set(const T_& val) { val_.reset(new Cumulant_<T_>(val)); }
