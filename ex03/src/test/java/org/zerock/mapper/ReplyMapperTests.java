package org.zerock.mapper;

import java.util.List;
import java.util.stream.IntStream;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.zerock.domain.Criteria;
import org.zerock.domain.ReplyVO;

import lombok.extern.log4j.Log4j;

/**
 * @author 82108
 *
 */
@RunWith(SpringJUnit4ClassRunner.class)
@Log4j
@ContextConfiguration({"file:src/main/webapp/WEB-INF/spring/root-context.xml"})
public class ReplyMapperTests {
	
	@Autowired
	private ReplyMapper mapper;
	
	private Long[] bnoArr = {2097176L,2097175L,2097174L,2097173L,2097172L};
	
	/**맵퍼 존재 여부 확인
	 * 
	 */
	@Test
	public void testMapper() {
		log.info(mapper);
	}
	@Test
	public void testCreate() {
		IntStream.rangeClosed(1, 10).forEach(i ->{
			ReplyVO vo = new ReplyVO();
			
			vo.setBno(bnoArr[i%5]);
			vo.setReply("댓글테스트" + i);
			vo.setReplyer("replyer" + i);
			mapper.insert(vo);
		});
	}
	@Test
	public void testRead() {
		ReplyVO vo = mapper.read(2L);
		log.info(vo);
	}

	@Test
	public void testDelete() {
		int result = mapper.delete(3L);
		log.info("결과 : " +  (result>0 ? "성공" :"실패"));
	}
	@Test
	public void testUpdate() {
		ReplyVO vo = new ReplyVO();
		vo.setRno(4L);
		vo.setReply("수정 내용");
		int result = mapper.update(vo);
		log.info(result>0?mapper.read(vo.getRno()) :  "======실패======");
	}
	@Test
	public void testList() {
		Criteria cri = new Criteria();
		List<ReplyVO> replies = mapper.getListWithPaging(cri, bnoArr[0]);
		replies.forEach(reply -> log.info(reply));
	}
	
	@Test
	public void testList2() {
		Criteria cri = new Criteria(2,10);
		List<ReplyVO> replies = mapper.getListWithPaging(cri, 4456506L);
		
		replies.forEach(reply -> log.info(reply));
	}
}
