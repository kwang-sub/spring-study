package org.zerock.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.mapper.BoardMapper;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Service
@Log4j
@AllArgsConstructor
public class BoardServiceImpl implements BoardService {
	
	@Autowired
	private BoardMapper mapper;
	
	@Override
	public void register(BoardVO board) {
		
		log.info(board);
		
		mapper.insertSelectKey(board);
	}

	@Override
	public BoardVO get(Long bno) {
		log.info("============get===========");
		return mapper.read(bno);
	}

	@Override
	public boolean modify(BoardVO board) {
		log.info("============Modify===========");
		
		return mapper.update(board)==1;
		
	}

	@Override
	public boolean remove(Long bno) {
		// TODO Auto-generated method stub
		log.info("============remove===========");
		return mapper.delete(bno)==1;
	}

	@Override
	public List<BoardVO> getList(Criteria cri) {
		
		log.info("============getList===========");
		return mapper.getListWithPaging(cri);
	}

	@Override
	public int getTotal(Criteria cri) {
		
		log.info("==========getTotal======");
		return mapper.getTotalCount(cri);
	}

}
