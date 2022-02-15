package org.zerock.controller;


import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.zerock.domain.SampleVO;
import org.zerock.domain.Ticket;

import lombok.extern.log4j.Log4j;

@RestController
@RequestMapping("/sample")
@Log4j
public class SampleController {
	
	/** 문자열 반환
	 * @return
	 */
	@GetMapping(value = "/getText", produces = "text/plain; charset=UTF-8")
	public String getText() {
		
		log.info("MIME TYPE: " + MediaType.TEXT_PLAIN_VALUE);
		return "안녕하세요";
	}
	
	/** 객체 반환
	 * @return
	 */
	@GetMapping(value = "/getSample")
	public SampleVO getSample() {
		return new SampleVO(112, "스타", "로드");
	}
	
	/** 컬렉션(List) 타입의 객체 반환
	 * @return
	 */
	@GetMapping("/getList")
	public List<SampleVO> getList(){
		return IntStream.range(1, 10).mapToObj( i -> new SampleVO(i, i + "First", i + " Last")).collect(Collectors.toList());
	}
	/**맵형식으로 데이터 전송
	 * @return
	 */
	@GetMapping(value = "/getMap")
	public Map<String, SampleVO> getMap(){
		
		Map<String, SampleVO> map = new HashMap<String, SampleVO>();
		map.put("First", new SampleVO(111, "test1", "test1"));
		
		return map;
	}
	
	/**상태코드와 함께 데이터를 보내는 방법
	 * @param height
	 * @param weight
	 * @return
	 */
	@GetMapping(value = "/check", params = {"height", "weight"})
	public ResponseEntity<SampleVO> check(Double height, Double weight){
		
		SampleVO vo = new SampleVO(0,"height : " +height, "weight : " + weight);
		
		ResponseEntity<SampleVO> result = null;
		if(height < 150) {
			result = ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(vo);
		}else {
			result = ResponseEntity.status(HttpStatus.OK).body(vo);
		}
		return result;
	}
	
	/**PathVariable 요청주소의 일부를 파라미터로 사용하는 방법
	 * @param cat
	 * @param pid
	 * @return
	 */
	@GetMapping("/product/{cat}/{pid}")
	public String[] getPath(@PathVariable("cat") String cat, @PathVariable("pid") String pid){
		return new String[] {"category : " + cat , "productid : " + pid};
	}
	
	@PostMapping("/ticket")
	public Ticket convert(@RequestBody Ticket ticket) {
		log.info("convert........ticket" + ticket);
		
		return ticket;
	}
}
