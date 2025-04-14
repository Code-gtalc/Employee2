package com.example.employee2;

import java.io.*;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "Servlet2", value = "/Employee XLSX")
public class Servlet2 extends HttpServlet {
    private String message;

    public void init() {
        message = "Hello World!";
    }

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        response.setContentType("text/html");

        // Get the filter options and search values from the request
        String column1 = request.getParameter("column1");
        String column2 = request.getParameter("column2");
        String column3 = request.getParameter("column3");
        String column4 = request.getParameter("column4");
        String column5 = request.getParameter("column5");
        String column6 = request.getParameter("column6");
        String column7 = request.getParameter("column7");
        String column8 = request.getParameter("column8");
        String[] columns = request.getParameterValues("columns");

        // Get the filter types for each column
        String filterColumn1 = request.getParameter("filter_column1");
        String filterColumn2 = request.getParameter("filter_column2");
        String filterColumn3 = request.getParameter("filter_column3");
        String filterColumn4 = request.getParameter("filter_column4");
        String filterColumn5 = request.getParameter("filter_column5");
        String filterColumn6 = request.getParameter("filter_column6");
        String filterColumn7 = request.getParameter("filter_column7");
        String filterColumn8 = request.getParameter("filter_column8");

        // Set the search values and filter types as request attributes
        request.setAttribute("column1", column1);
        request.setAttribute("column2", column2);
        request.setAttribute("column3", column3);
        request.setAttribute("column4", column4);
        request.setAttribute("column5", column5);
        request.setAttribute("column6", column6);
        request.setAttribute("column7", column7);
        request.setAttribute("column8", column8);
        request.setAttribute("columns", columns);
        request.setAttribute("filter_column1", filterColumn1);
        request.setAttribute("filter_column2", filterColumn2);
        request.setAttribute("filter_column3", filterColumn3);
        request.setAttribute("filter_column4", filterColumn4);
        request.setAttribute("filter_column5", filterColumn5);
        request.setAttribute("filter_column6", filterColumn6);
        request.setAttribute("filter_column7", filterColumn7);
        request.setAttribute("filter_column8", filterColumn8);

        // Forward the request to the JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/XLS.jsp");
        dispatcher.forward(request, response);
    }

    public void destroy() {
    }
}