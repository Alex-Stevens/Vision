package resultItem;

public class resultItem implements Comparable<resultItem>
{
	int ProductID;
	Integer Score;
	
	public int compareTo(resultItem other) 
	{
        return Score.compareTo(other.getScore());
    }
	
	public resultItem (int inputtedProductID, int inputtedScore)
	{
		ProductID = inputtedProductID;
		Score = inputtedScore;
	}
	
	public void setProductID (int inputtedProductID)
	{
		ProductID = inputtedProductID;
	}
	
	public int getProductID()
	{
		return ProductID;
	}
	
	public void setScore(int inputtedScore)
	{
		Score = inputtedScore;
	}
	
	public int getScore()
	{
		return Score;
	}
}