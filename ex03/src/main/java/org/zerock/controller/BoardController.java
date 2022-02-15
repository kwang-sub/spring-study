package org.zerock.controller;


import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Log4j
@Controller
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {
	
	private BoardService service;
	
	@GetMapping("/list")
	public void list(Criteria cri,Model model) {
		log.info("list : " + cri);
		int total = service.getTotal(cri);
		log.info("total" + total);
		
		model.addAttribute("list", service.getList(cri));
		model.addAttribute("pageMaker", new PageDTO(cri, total));
		
	}
	@PostMapping("/register")
	public String register(BoardVO board, RedirectAttributes rttr, Model model) {
		service.register(board);
		log.info("register : " + board);
		rttr.addFlashAttribute("result", board.getBno());
		return "redirect:/board/list";
	}
	@GetMapping({"/get", "/modify"})
	public void get(@RequestParam("bno") Long bno, Model model, @ModelAttribute("cri") Criteria cri) {
		
		log.info("/get or modify");
		model.addAttribute("board", service.get(bno));
		
	}
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
		
		log.info("modify");
		if(service.modify(board)) {
			rttr.addFlashAttribute("result", "성공");
		}else {
			rttr.addFlashAttribute("result", "실패");
		}
		rttr.addAttribute("keyword",cri.getKeyword());
		rttr.addAttribute("type", cri.getType());
		rttr.addAttribute("pageNum", cri.getPageNum());
		rttr.addAttribute("amount", cri.getAmount());
		
		return "redirect:/board/list";
	}
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, RedirectAttributes rttr,@ModelAttribute("cri") Criteria cri) {
		
		log.info("remove : " + bno);
		if(service.remove(bno)) {
			rttr.addFlashAttribute("result", "성공");
		}else {
			rttr.addFlashAttribute("result", "실패");
			
		}

		
		return "redirect:/board/list" + cri.getListLink();
	}
	
	@GetMapping("/register")
	public void register() {
		
	}
}
