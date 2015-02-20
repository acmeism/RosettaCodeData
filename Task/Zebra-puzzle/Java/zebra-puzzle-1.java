package zebra;

public class LineOfPuzzle implements Cloneable{

    private Integer order;
    private String nation;
    private String color;
    private String animal;
    private String drink;
    private String cigarette;

    private LineOfPuzzle rightNeighbor;
    private LineOfPuzzle leftNeighbor;
    private PuzzleSet<LineOfPuzzle> undefNeighbors;

    public LineOfPuzzle (Integer order, String nation, String color,
                         String animal, String drink, String cigarette){

        this.animal=animal;
        this.cigarette=cigarette;
        this.color=color;
        this.drink=drink;
        this.nation=nation;
        this.order=order;
    }

    public Integer getOrder() {
        return order;
    }

    public void setOrder(Integer order) {
        this.order = order;
    }

    public String getNation() {
        return nation;
    }

    public void setNation(String nation) {
        this.nation = nation;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public String getAnimal() {
        return animal;
    }

    public void setAnimal(String animal) {
        this.animal = animal;
    }

    public String getDrink() {
        return drink;
    }

    public void setDrink(String drink) {
        this.drink = drink;
    }

    public String getCigarette() {
        return cigarette;
    }

    public void setCigarette(String cigarette) {
        this.cigarette = cigarette;
    }

    /**
     * Overrides object equal method
     * @param obj
     * @return
     */
    @Override
    public boolean equals(Object obj) {
        if (obj instanceof LineOfPuzzle){
            LineOfPuzzle searchLine = (LineOfPuzzle)obj;
            return  this.getWholeLine().equalsIgnoreCase(searchLine.getWholeLine());
        }
        else
            return false;
    }

    public int getFactsCount(){
        int facts = 0;
        facts+=this.getOrder()!=null?1:0;
        facts+=this.getNation()!=null?1:0;
        facts+=this.getColor()!=null?1:0;
        facts+=this.getAnimal()!=null?1:0;
        facts+=this.getCigarette()!=null?1:0;
        facts+=this.getDrink()!=null?1:0;
        return facts;
    }

    public int getCommonFactsCount(LineOfPuzzle lineOfFacts){
        int ordrCmp = (this.order!=null && lineOfFacts.getOrder()!= null &&
                       this.order.intValue()== lineOfFacts.getOrder().intValue())?1:0;

        int natnCmp = (this.nation!=null && lineOfFacts.getNation()!= null &&
                       this.nation.equalsIgnoreCase(lineOfFacts.getNation()))?1:0;

        int colrCmp = (this.color!=null && lineOfFacts.getColor()!= null &&
                       this.color.equalsIgnoreCase(lineOfFacts.getColor()))?1:0;

        int petsCmp = (this.animal!=null && (lineOfFacts.getAnimal()!= null &&
                       this.animal.equalsIgnoreCase(lineOfFacts.getAnimal())))?1:0;

        int cigrCmp = (this.cigarette!=null && lineOfFacts.getCigarette()!= null &&
                       this.cigarette.equalsIgnoreCase(lineOfFacts.getCigarette()))?1:0;

        int drnkCmp = (this.drink!=null && lineOfFacts.getDrink()!= null &&
                       this.drink.equalsIgnoreCase(lineOfFacts.getDrink()))?1:0;

        int result = (ordrCmp + natnCmp + colrCmp + petsCmp + cigrCmp + drnkCmp);

        return result;
    }

    public void addUndefindedNeighbor(LineOfPuzzle newNeighbor){
        if (this.undefNeighbors==null)
            this.undefNeighbors = new PuzzleSet<>();

        this.undefNeighbors.add(newNeighbor);
    }

    public boolean hasUndefNeighbors(){
        return (this.undefNeighbors!=null);
    }

    public PuzzleSet<LineOfPuzzle> getUndefNeighbors(){
        return this.undefNeighbors;
    }

    public void setLeftNeighbor(LineOfPuzzle leftNeighbor){
        this.leftNeighbor = leftNeighbor;
        this.leftNeighbor.setOrder(this.order - 1);
    }

    public void setRightNeighbor(LineOfPuzzle rightNeighbor){
        this.rightNeighbor=rightNeighbor;
        this.rightNeighbor.setOrder(this.order + 1);
    }

    public boolean hasLeftNeighbor(){
        return (leftNeighbor!=null);
    }

    public LineOfPuzzle getLeftNeighbor(){
        return this.leftNeighbor;
    }

    public boolean hasNeighbor(int direction){
        if (direction < 0)
            return (leftNeighbor!=null);
        else
            return (rightNeighbor!=null);
    }

    public boolean hasRightNeighbor(){
        return (rightNeighbor!=null);
    }

    public LineOfPuzzle getRightNeighbor(){
        return this.rightNeighbor;
    }

    public LineOfPuzzle getNeighbor(int direction){
        if (direction < 0)
            return this.leftNeighbor;
        else
            return this.rightNeighbor;
    }

    public String getWholeLine() {
        String sLine = this.order + " - " +
                       this.nation + " - " +
                       this.color + " - " +
                       this.animal + " - " +
                       this.drink + " - " +
                       this.cigarette;
            return sLine;
    }

    @Override
    public int hashCode() {
        int sLine = (this.order + " - " +
                     this.nation + " - " +
                     this.color + " - " +
                     this.animal + " - " +
                     this.drink + " - " +
                     this.cigarette
                ).hashCode();
        return sLine;
    }

    public void merge(LineOfPuzzle mergedLine){
        if (this.order == null) this.order = mergedLine.order;
        if (this.nation == null) this.nation = mergedLine.nation;
        if (this.color == null) this.color = mergedLine.color;
        if (this.animal == null) this.animal = mergedLine.animal;
        if (this.drink == null) this.drink = mergedLine.drink;
        if (this.cigarette == null) this.cigarette = mergedLine.cigarette;
    }


    public LineOfPuzzle clone() {
        try {
            return (LineOfPuzzle) super.clone();
        } catch (CloneNotSupportedException e) {
            e.printStackTrace();
            throw new RuntimeException();
        }
    }
}
