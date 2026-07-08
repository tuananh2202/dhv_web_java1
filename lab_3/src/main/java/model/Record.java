package model;

public class Record {

    private int id;
    private String stname;
    private String courses;
    private int fee;

    public Record() {
    }

    public Record(int id, String stname, String courses, int fee) {
        this.id = id;
        this.stname = stname;
        this.courses = courses;
        this.fee = fee;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getStname() {
        return stname;
    }

    public void setStname(String stname) {
        this.stname = stname;
    }

    public String getCourses() {
        return courses;
    }

    public void setCourses(String courses) {
        this.courses = courses;
    }

    public int getFee() {
        return fee;
    }

    public void setFee(int fee) {
        this.fee = fee;
    }
}
