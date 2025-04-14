<%@ page contentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>
<%@ page import="net.sf.jasperreports.engine.JRException" %>
<%@ page import="net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter" %>
<%@ page import="net.sf.jasperreports.export.SimpleXlsxReportConfiguration"%>
<%@ page import="net.sf.jasperreports.export.SimpleExporterInput" %>
<%@ page import="net.sf.jasperreports.export.SimpleOutputStreamExporterOutput" %>

<%!
    // Function to get column name based on the parameter
    String getColumnName(String param) {
        switch (param) {
            case "column1":
                return "employees.emp_no";
            case "column2":
                return "employees.birth_date";
            case "column3":
                return "employees.first_name";
            case "column4":
                return "employees.last_name";
            case "column5":
                return "employees.gender";
            case "column6":
                return "employees.hire_date";
            case "column7":
                return "dept_emp.dept_no";
            case "column8":
                return "titles.title";
            default:
                return "";
        }
    }
%>

<%
    String rowId = "1";
    Connection conn = null;
    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/employees", "root", "");

        //Loading Jasper Report File from Local file system
        String jrxmlFile = session.getServletContext().getRealPath("/Employee2.jrxml");

        InputStream input = new FileInputStream(new File(jrxmlFile));

        //Generating the report
        JasperReport jasperReport = JasperCompileManager.compileReport(input);
        Map<String, Object> parameters = new HashMap<>();


        parameters.put("rowid", rowId);
        //parameters.put(JRParameter.REPORT_MAX_COUNT, 1000);

        // Get the nameStartsWith parameter from the request
        String nameStartsWith = request.getParameter("nameStartsWith");
        String[] columns = request.getParameterValues("columns");
        Set<String> columnSet = columns != null ? new HashSet<>(Arrays.asList(columns)) : new HashSet<>();


        parameters.put("columns", columnSet);
        parameters.put("show_id", columnSet.contains("column1"));
        parameters.put("show_dob", columnSet.contains("column2"));
        parameters.put("show_fname", columnSet.contains("column3"));
        parameters.put("show_lname", columnSet.contains("column4"));
        parameters.put("show_gender", columnSet.contains("column5"));
        parameters.put("show_hdate", columnSet.contains("column6"));
        parameters.put("show_dept", columnSet.contains("column7"));
        parameters.put("show_title", columnSet.contains("column8"));


        // SQL query builder
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM employees LEFT JOIN dept_emp ON employees.emp_no=dept_emp.emp_no LEFT JOIN titles ON employees.emp_no=titles.emp_no WHERE 1=1");

        // Filter parameters
        List<String> filterParams = new ArrayList<>();
        for (String column : columnSet) {
            if (!column.equals("column5")) { // Skip gender column
                String searchValue = (String) request.getAttribute(column);
                String filterType = (String) request.getAttribute("filter_" + column);

                if (searchValue != null && !searchValue.isEmpty() && filterType != null) {
                    switch (filterType) {
                        case "startsWith":
                            sqlBuilder.append(" AND ").append(getColumnName(column)).append(" LIKE ?");
                            filterParams.add(searchValue + "%");
                            break;
                        case "endsWith":
                            sqlBuilder.append(" AND ").append(getColumnName(column)).append(" LIKE ?");
                            filterParams.add("%" + searchValue);
                            break;
                        case "contains":
                            sqlBuilder.append(" AND ").append(getColumnName(column)).append(" LIKE ?");
                            filterParams.add("%" + searchValue + "%");
                            break;
                    }
                }
            }
        }

        // Handle gender filter separately
        if (columnSet.contains("column5")) {
            String gender = (String) request.getAttribute("column5");
            if (gender != null && !gender.isEmpty() && !gender.equals("Both")) {
                sqlBuilder.append(" AND employees.gender = ?");
                filterParams.add(gender);
            }
        }

        sqlBuilder.append(" GROUP BY employees.emp_no LIMIT 1000");

        PreparedStatement statement = conn.prepareStatement(sqlBuilder.toString());

        // Setting filter parameters
        for (int i = 0; i < filterParams.size(); i++) {
            statement.setString(i + 1, filterParams.get(i));
        }

        ResultSet resultSet = statement.executeQuery();
        JRResultSetDataSource dataSource = new JRResultSetDataSource(resultSet);
        parameters.put("REPORT_CONNECTION", conn);

        //JasperReport jasperReport = JasperCompileManager.compileReport(input);
        JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, dataSource);
        if (jasperPrint.getPages().size() == 0) {
            // Write error message to response
            response.setContentType("text/html");
            response.getWriter().println("<h1>No data found for the selected filters.</h1>");
            conn.close();
        }
        else {
            // Excel output
            ByteArrayOutputStream ostream = new ByteArrayOutputStream();

            JRXlsxExporter exporter = new JRXlsxExporter();
            SimpleXlsxReportConfiguration configuration = new SimpleXlsxReportConfiguration();

            exporter.setExporterInput(new SimpleExporterInput(jasperPrint));
            exporter.setExporterOutput(new SimpleOutputStreamExporterOutput(ostream));

            configuration.setIgnoreGraphics(false);
            exporter.setConfiguration(configuration);
            exporter.exportReport();

            byte[] bytes = ostream.toByteArray();

            if (bytes != null && bytes.length > 0) {
                response.reset();
                response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
                response.setHeader("Content-Disposition", "inline; filename=Employee XLSX.xlsx");
                response.setContentLength(bytes.length);
                ServletOutputStream outputStream = response.getOutputStream();
                outputStream.write(bytes, 0, bytes.length);
                outputStream.flush();
                outputStream.close();
            } else {
                System.out.print("bytes were null!");
            }
        }
    } catch (JRException ex) {
        System.out.print("Jasper output error:" + ex.getMessage());
    } catch (SQLException e) {
        throw new RuntimeException(e);
    } finally {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }
%>