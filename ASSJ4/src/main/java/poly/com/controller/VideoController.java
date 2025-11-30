package poly.com.controller;

import java.util.List;

import poly.com.dao.VideoDao;
import poly.com.entity.*;
public class VideoController {
	 private VideoDao videoDao = new VideoDao();

	    // 1️⃣ Lấy tất cả video
	    public List<Video> getAllVideos() {
	        return videoDao.findAll();
	    }

	    // 2️⃣ Lấy video theo ID
	    public Video getVideoById(String id) {
	        return videoDao.findById(id);
	    }

	    // 3️⃣ Thêm video mới
	    public void addVideo(Video video) {
	        videoDao.insert(video);
	    }

	    // 4️⃣ Cập nhật video
	    public void updateVideo(Video video) {
	        videoDao.update(video);
	    }

	    // 5️⃣ Xóa video theo ID
	    public void deleteVideo(String id) {
	        videoDao.delete(id);
	    }
}
