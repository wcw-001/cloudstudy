package com.zyfgoup.words;

import com.zyfgoup.exceImpl.ReadWordsException;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.core.io.DefaultResourceLoader;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Component;
import org.springframework.util.CollectionUtils;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.util.*;

/**
 * @Author Zyfgoup
 * @Date 2021/1/28 16:27
 * @Description
 *
 */
@Slf4j
@Component
public class WordFilter implements InitializingBean {
    private final static String WORDS = "WORDS";
    private final static String REPLACE_CHAR = "*";
    private static HashMap sensitiveWordMap;
    /**     * 最小匹配规则     */
    private static int minMatchTYpe = 1;
    /**     * 最大匹配规则     */
    private static int maxMatchType = 2;
    /**
     * 敏感词汇过滤替换为*     *
     * @param text 待检测文字
     * @return 替换后文字
     */
    public static String replaceWords(String text) {
        if (StringUtils.isBlank(text)) {
            return text;
        }
        //替换敏感词汇为*
        return WordFilter.replaceSensitiveWord(text, WordFilter.minMatchTYpe);
    }

    /**
     * 判断是否含有敏感词
     * @param text
     * @return
     */
    public static boolean haveSensitiveWord(String text) {
        if (StringUtils.isBlank(text)) {
            return false;
        }
        //缓存获取敏感词汇原记录
        List<String> words = Cache.get(WORDS);
        if (CollectionUtils.isEmpty(words)) {
            //读取敏感词汇文件，存入缓存
            words = readWordsFile();
            Cache.put(WORDS, words);
        }

        if (sensitiveWordMap == null) {
            addSensitiveWord(words);
        }
        //获取所有的敏感词
        List<String> set = getSensitiveWord(text,WordFilter.minMatchTYpe);
        return set.size()!=0;
    }

    /**
     * 读取敏感词汇文件
     */
    private static List<String> readWordsFile() {
        List<String> list = new ArrayList<>();
        InputStream inputStream = null;
        InputStreamReader inputStreamReader = null;
        BufferedReader bufferedReader = null;
        try {
            Resource resource = new DefaultResourceLoader().getResource("classpath:words.txt");
            inputStream = resource.getInputStream();
            inputStreamReader = new InputStreamReader(inputStream, StandardCharsets.UTF_8);
            bufferedReader = new BufferedReader(inputStreamReader);
            String txt = "";
            while (StringUtils.isNotBlank(txt = bufferedReader.readLine())) {
                list.addAll(
                        Arrays.asList(
                                StringUtils.split(
                                        StringUtils.deleteWhitespace(StringUtils.replace(txt, "，", ",")),
                                        ","
                                )
                        )
                );
            }
            bufferedReader.close();
            inputStreamReader.close();
            inputStream.close();
        } catch (Exception e) {
            log.error("读取敏感词汇文件出错", e);
        } finally {
            try {
                if (bufferedReader != null) {
                    bufferedReader.close();
                }
                if (inputStreamReader != null) {
                    inputStreamReader.close();
                }
                if (inputStream != null) {
                    inputStream.close();
                }
            } catch (Exception e) {
                log.error("读取敏感词汇文件出错", e);
            }
        }
        return list;
    }
    /**
     * 替换敏感字字符
     *
     * @param txt       待检查文本
     * @param matchType 匹配规则
     */
    private static String replaceSensitiveWord(String txt, int matchType) {
        String resultTxt = txt;
        //获取所有的敏感词
        List<String> set = getSensitiveWord(txt, matchType);
        Iterator<String> iterator = set.iterator();
        while (iterator.hasNext()) {
            resultTxt = resultTxt.replaceAll(iterator.next(), REPLACE_CHAR);
        }
        return resultTxt;
    }


    /**
     * 读取敏感词库，将敏感词放入HashSet中，构建一个DFA算法模型：
     * 说明：该方法来源于互联网
     */
    private static void addSensitiveWord(List<String> datas) {
        sensitiveWordMap = new HashMap(datas.size());
        Iterator<String> iterator = datas.iterator();
        Map<String, Object> now = null;
        Map now2 = null;
        while (iterator.hasNext()) {
            now2 = sensitiveWordMap;
            String word = iterator.next().trim(); //敏感词
            for (int i = 0; i < word.length(); i++) {
                char key_word = word.charAt(i);
                Object obj = now2.get(key_word);
                if (obj != null) { //存在
                    now2 = (Map) obj;
                } else { //不存在
                    now = new HashMap<String, Object>();
                    now.put("isEnd", "0");
                    now2.put(key_word, now);
                    now2 = now;
                }
                if (i == word.length() - 1) {
                    now2.put("isEnd", "1");
                }
            }
        }
    }

    /**
     * 获取内容中的敏感词
     *说明：该方法来源于互联网
     * @param text      内容
     * @param matchType 匹配规则 1=不最佳匹配，2=最佳匹配
     * @return
     */
    private static List<String> getSensitiveWord(String text, int matchType) {
        List<String> words = new ArrayList<String>();
        Map now = sensitiveWordMap;
        int count = 0; //初始化敏感词长度
        int start = 0; //标志敏感词开始的下标
        for (int i = 0; i < text.length(); i++) {
            char key = text.charAt(i);
            now = (Map) now.get(key);
            if (now != null) { //存在
                count++;
                if (count == 1) {
                    start = i;
                }
                if ("1".equals(now.get("isEnd"))) { //敏感词结束
                    now = sensitiveWordMap; //重新获取敏感词库
                    words.add(text.substring(start, start + count)); //取出敏感词，添加到集合
                    count = 0; //初始化敏感词长度
                }
            } else { //不存在
                now = sensitiveWordMap;//重新获取敏感词库
                if (count == 1 && matchType == 1) { //不最佳匹配
                    count = 0;
                } else if (count == 1 && matchType == 2) { //最佳匹配
                    words.add(text.substring(start, start + count));
                    count = 0;
                }
            }
        }
        return words;
    }
    public WordFilter() {
        super();
    }


    /**
     * 读取敏感词汇文件，存入缓存
     * @throws Exception
     */
    @Override
    public void afterPropertiesSet() throws Exception {
        try {
            List<String> words = readWordsFile();
            Cache.put(WORDS, words);
            addSensitiveWord(words);
        }catch (Exception e){
            throw new ReadWordsException();
        }
    }

}
