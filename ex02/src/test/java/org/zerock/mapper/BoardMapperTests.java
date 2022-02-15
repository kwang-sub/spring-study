package org.zerock.mapper;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;

import lombok.extern.log4j.Log4j;

@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration("file:src/main/webapp/WEB-INF/spring/root-context.xml")
public class BoardMapperTests {
	
	@Autowired
	private BoardMapper mapper;
	
	/*
	 * @Test public void testGetList() {
	 * 
	 * mapper.getList().forEach(board -> log.info(board)); }
	 */
	
	@Test
	public void testInsert() {
		BoardVO board = new BoardVO();
		board.setTitle("새로운 제목");
		board.setContent("새로운 내용");
		board.setWriter("작성자");
		mapper.insert(board);
		log.info("==================insert" + board);
	}
	
	@Test
	public void testInsertSelectKey() {
		BoardVO board = new BoardVO();
		board.setTitle("새로운 제목");
		board.setContent("새로운 내용");
		board.setWriter("작성자");
		mapper.insertSelectKey(board);
		log.info("==================insertSelectKey" + board);
	}
	
	@Test
	public void testRead() {
		BoardVO board = mapper.read(22L);
		log.info("==================read" + board);
	}
	
	@Test
	public void testDelete() {
		log.info("==================DELETE COUNT: " + mapper.delete(23L));
	}
	@Test
	public void testUpdate() {
		BoardVO board = new BoardVO();
		board.setBno(1L);
		board.setTitle("수정 제목");
		board.setContent("수정 내용");
		board.setWriter("수정");
		int result  = mapper.update(board);
		log.info("==================update: " + result);
		
	}
	
	@Test
	public void testPaging() {
		Criteria cri = new Criteria();
		cri.setAmount(10);
		cri.setPageNum(3);
		List<BoardVO> list = mapper.getListWithPaging(cri);
		list.forEach(board -> log.info(board));
	}
	
	@Test
	public void testSearch() {
		
		Criteria cri = new Criteria();
		cri.setKeyword("새로");
		cri.setType("TC");
		
		List<BoardVO> list = mapper.getListWithPaging(cri);
		
		list.forEach(board -> log.info(board));
	}
}
