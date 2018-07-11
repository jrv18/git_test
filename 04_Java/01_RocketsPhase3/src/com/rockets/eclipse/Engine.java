package com.rockets.eclipse;

public class Engine {
	private int power;

	public Engine(int power) {
		this.power = power;
	}

	public int getPower() {
		return this.power;
	}

	public void setPower(int power) {
		this.power = power;
	}

	/**
	 * 	This three lines of code have some overhead
	 *  	String myStr = new String();
	 *  	myStr = "" + this.power;
	 *  	return myStr;
	 *  
	 *  are equivalent to
	 *  	return String.valueOf(this.power);
	 *  or
	 *  	return Integer.toString(this.power);
	 *  
	 *  Always use either String.valueOf(number) or Integer.toString(number).
	 *  Using "" + number is an overhead and does the following:
	 *      StringBuilder sb = new StringBuilder();
	 *      sb.append("");
	 *      sb.append(number);
	 *      return sb.toString();
	 *  
	 */
	@Override
	public String toString() {
		return String.valueOf(this.power);
	}
	
}	
