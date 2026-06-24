package dao;

import context.DBContext;
import model.Record;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class RecordDAO {

    public RecordDAO() {
    }

    public List<Record> getAllRecords() {
        List<Record> list = new ArrayList<>();
        String sql = "SELECT id, stname, courses, fee FROM records";

        try (
                Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()
        ) {
            while (rs.next()) {
                Record r = new Record(
                        rs.getInt("id"),
                        rs.getString("stname"),
                        rs.getString("courses"),
                        rs.getInt("fee")
                );
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean insertRecord(Record record) {
        String sql = "INSERT INTO records(stname, courses, fee) VALUES(?, ?, ?)";

        try (
                Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, record.getStname());
            ps.setString(2, record.getCourses());
            ps.setInt(3, record.getFee());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean updateRecord(Record record) {
        String sql = "UPDATE records SET stname = ?, courses = ?, fee = ? WHERE id = ?";

        try (
                Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setString(1, record.getStname());
            ps.setString(2, record.getCourses());
            ps.setInt(3, record.getFee());
            ps.setInt(4, record.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public boolean deleteRecord(int id) {
        String sql = "DELETE FROM records WHERE id = ?";

        try (
                Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    public Record getRecordById(int id) {
        String sql = "SELECT id, stname, courses, fee FROM records WHERE id = ?";

        try (
                Connection conn = new DBContext().getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)
        ) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Record(
                            rs.getInt("id"),
                            rs.getString("stname"),
                            rs.getString("courses"),
                            rs.getInt("fee")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}