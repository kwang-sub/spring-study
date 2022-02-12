package org.zerock.service;

import static org.junit.Assert.assertNotNull;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
@Log4j
public class BoardServiceTests {
	
	@Autowired
	private BoardService service;
	
	@Test
	public void testExist() {
		log.info("==========service: " + service);
		assertNotNull(service);
	}
	
	@Test
	public void testRegister() {
		BoardVO board = new BoardVO();
		board.setTitle("작성 제목");
		board.setContent("작성내용");
		board.setWriter("작성자");
		
		service.register(board);
		log.info("========register: " + board.getBno());
	}
	
	@Test
	public void testGetList() {
		service.getList().forEach( board -> log.info(board) );
	}
	
	@Test
	public void testGet() {
		log.info("=============get: " + service.get(1L));
	}
	
	@Test
	public void testDelete() {
		log.info("=========delete: " + service.remove(34L));
	}
	
	@Test
	public void testUpdate() {
		BoardVO board = service.get(1L);
		
		if(board == null) return;
		
		board.setTitle("제목수정");
		log.info("==========modify: " + service.modify(board));
	}
}
