package org.zerock.controller;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.web.context.WebApplicationContext;

import lombok.Setter;
import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration({
	"file:src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml",
	"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
@Log4j
@WebAppConfiguration
public class BoardControllerTests {
	
	@Setter(onMethod_ = @Autowired)
	private WebApplicationContext ctx;
	
	private MockMvc mockMvc;
	
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(ctx).build();
	}
	
	@Test
	public void testList() throws Exception{
		
		log.info("==============List"+
			mockMvc.perform(MockMvcRequestBuilders.get("/board/list"))	
				.andReturn()
				.getModelAndView()
				.getModelMap());
	}
	
	@Test
	public void testRegister() throws Exception{
		
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/register")
				.param("title", "테스트 새글제목")
				.param("content", "테스트 새글내용")
				.param("writer", "user00")
			).andReturn().getModelAndView().getViewName();
		log.info("============register: " + resultPage);	
	}
	
	@Test
	public void testGet() throws Exception{
		
		log.info("===========get"+ 
			mockMvc.perform(MockMvcRequestBuilders.get("/board/get")
					.param("bno", "1"))
					.andReturn()
					.getModelAndView()
					.getModelMap());
	}
	
	@Test
	public void testModify() throws Exception{
		
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/modify")
				.param("bno", "1")
				.param("title", "테스트 수정제목")
				.param("content", "테스트 수정내용")
				.param("writer", "user00"))
				.andReturn().getModelAndView().getViewName();
		
		log.info("==========modify: " + resultPage);
	}
	
	@Test
	public void testRemmove() throws Exception{
		
		String resultPage = mockMvc.perform(MockMvcRequestBuilders.post("/board/remove")
				.param("bno", "43"))
				.andReturn().getModelAndView().getViewName();
		
		log.info("=============remove: "+ resultPage);
	}
}
